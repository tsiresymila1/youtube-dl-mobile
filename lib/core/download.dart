import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_localization/easy_localization.dart';
import 'log.dart';

import 'package:youtube_dl/core/models/video_item/video_item.dart';

typedef DownloadProgressCallback = void Function(double progress, VideoStatus status);

String _getOutputFilepath(String parent, String filename, String ext) {
  String outputPath = "$parent/$filename.$ext";
  int counter = 0;
  while (File(outputPath).existsSync()) {
    counter++;
    outputPath = "$parent/$filename($counter).$ext";
  }
  return outputPath;
}

Future<void> _mergeAudioVideo(File audio, File video, String outputPath, DownloadProgressCallback onProgress) async {
  onProgress(0.9, VideoStatus.merging);
  
  // YouTube HLS streams require a whitelist for network protocols
  // We also try to use copy for faster processing if possible, but the user requested robustness,
  // so we stick to libx264/aac which is highly compatible.
  logger.d("Merging audio and video (Fast Copy): ${audio.path} + ${video.path} -> $outputPath");
  
  // Try fast copy first (almost instantaneous)
  final fastArguments = [
    "-i", video.path,
    "-i", audio.path,
    "-c", "copy",
    "-map", "0:v:0",
    "-map", "1:a:0",
    "-shortest",
    outputPath
  ];

  var session = await FFmpegKit.executeWithArguments(fastArguments);
  var returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    logger.i("Fast merge (copy) successful");
    if (audio.existsSync()) audio.deleteSync();
    if (video.existsSync()) video.deleteSync();
    onProgress(1.0, VideoStatus.finished);
    return;
  }

  // Fallback to transcoding if copy fails
  logger.w("Fast merge failed, falling back to transcoding...");
  final transcodeArguments = [
    "-i", video.path,
    "-i", audio.path,
    "-c:v", "libx264",
    "-c:a", "aac",
    "-preset", "superfast",
    outputPath
  ];

  await FFmpegKit.executeWithArguments(transcodeArguments).then((session) async {
    final returnCode = await session.getReturnCode();
    if (audio.existsSync()) audio.deleteSync();
    if (video.existsSync()) video.deleteSync();
    
    if (!ReturnCode.isSuccess(returnCode)) {
      final logs = await session.getLogsAsString();
      logger.e("Merge failed: $logs");
      onProgress(0, VideoStatus.failed);
    } else {
      onProgress(1.0, VideoStatus.finished);
    }
  });
}

Future<void> _convertToMp3(File audio, String outputPath, DownloadProgressCallback onProgress) async {
  onProgress(0.9, VideoStatus.converting);
  
  final arguments = [
    "-i", audio.path,
    "-vn",
    "-c:a", "libmp3lame",
    "-b:a", "192k",
    outputPath
  ];

  await FFmpegKit.executeWithArguments(arguments).then((session) async {
    final returnCode = await session.getReturnCode();
    if (audio.existsSync()) audio.deleteSync();
    
    if (ReturnCode.isSuccess(returnCode)) {
      onProgress(1.0, VideoStatus.finished);
    } else {
      final logs = await session.getLogsAsString();
      logger.e("Conversion failed: $logs");
      onProgress(0, VideoStatus.failed);
      Fluttertoast.showToast(
        msg: "Conversion to MP3 failed!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  });
}

Future<String> processDownload({
  required List<Map<String, dynamic>> futures,
  String? videoId,
  required String filename,
  required String name,
  required bool mp3,
  required DownloadProgressCallback onProgress,
}) async {
  final dio = Dio();
  final tempDir = await getTemporaryDirectory();
  logger.i('Starting processDownload for $name, destination: /storage/emulated/0/Download');

  // Final download destination
  final downloadDir = Directory('/storage/emulated/0/Download');
  if (!downloadDir.existsSync()) {
    downloadDir.createSync(recursive: true);
  }

  Map<String, double> progresses = {};
  for (var f in futures) {
    progresses[f['name']] = 0.0;
  }

  Map<String, File> downloadedFiles = {};

  try {
    final prefs = await SharedPreferences.getInstance();
    final cookies = prefs.getString('youtube_cookies') ?? '';

    final cancelToken = CancelToken();

    await Future.wait(futures.map((item) async {
      final String downloadPath = "${tempDir.path}/${item['name']}";
      final String type = item['type'] ?? 'unknown';
      final String? url = item['url'];
      
      if (url == null) {
        logger.e("No URL provided for ${item['name']}");
        return;
      }

      int retryCount = 0;
      const int maxRetries = 3;
      bool success = false;

      while (retryCount < maxRetries && !success) {
        try {
          if (retryCount > 0) {
            logger.i("Retrying download for ${item['name']} (Attempt ${retryCount + 1}/$maxRetries)...");
            await Future.delayed(Duration(seconds: 2 * retryCount));
          }

          if (cancelToken.isCancelled) return;

          logger.i('Starting direct Dio download: ${item['name']}');
          
          final Map<String, dynamic> headers = {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
          };

          if (cookies.isNotEmpty) {
            headers['Cookie'] = cookies;
          }

          await dio.download(
            url,
            downloadPath,
            cancelToken: cancelToken,
            options: Options(
              headers: headers,
            ),
            onReceiveProgress: (count, total) {
              if (total != -1) {
                progresses[item['name']] = count.toDouble() / total.toDouble();
                double totalProgress =
                    progresses.values.reduce((a, b) => a + b) / progresses.length;
                onProgress(totalProgress * 0.9, VideoStatus.downloading);
              }
            },
          );
          
          success = true;
          downloadedFiles[type] = File(downloadPath);
          logger.i('Finished downloading ${item['name']}');
        } catch (e) {
          if (e is DioException) {
            if (e.response?.statusCode == 403) {
              logger.e("403 Forbidden detected for ${item['name']}. Cancelling all downloads.");
              cancelToken.cancel("Forbidden");
              Fluttertoast.showToast(
                msg: "video_format_unavailable".tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
              );
              rethrow;
            }
            if (CancelToken.isCancel(e)) {
              logger.w("Download cancelled for ${item['name']}");
              return;
            }
          }
          retryCount++;
          logger.e("Error during parallel download attempt $retryCount for ${item['name']}: $e");
          if (retryCount >= maxRetries) rethrow;
        }
      }
    }));

    final String extension = mp3 ? 'mp3' : 'mp4';
    final outputPath =
        _getOutputFilepath(downloadDir.path, filename, extension);

    final audioFile = downloadedFiles['audio'];
    final videoFile = downloadedFiles['video'];

    if (mp3) {
      if (audioFile != null) {
        await _convertToMp3(audioFile, outputPath, onProgress);
      } else if (videoFile != null) {
        await _convertToMp3(videoFile, outputPath, onProgress);
      } else {
        throw Exception("No audio or video found for MP3 conversion");
      }
    } else {
      if (videoFile != null && audioFile != null) {
        await _mergeAudioVideo(audioFile, videoFile, outputPath, onProgress);
      } else if (videoFile != null) {
        onProgress(0.95, VideoStatus.merging);
        final remuxArgs = [
          "-i", videoFile.path,
          "-c", "copy",
          outputPath
        ];
        var session = await FFmpegKit.executeWithArguments(remuxArgs);
        var returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          if (videoFile.existsSync()) videoFile.deleteSync();
          onProgress(1.0, VideoStatus.finished);
        } else {
          final transcodeArgs = [
            "-i", videoFile.path,
            "-c:v", "libx264",
            "-c:a", "aac",
            "-preset", "superfast",
            outputPath
          ];
          session = await FFmpegKit.executeWithArguments(transcodeArgs);
          if (videoFile.existsSync()) videoFile.deleteSync();
          onProgress(1.0, VideoStatus.finished);
        }
      } else if (audioFile != null) {
        final originalExt = audioFile.path.split('.').last;
        final actualOutputPath = _getOutputFilepath(downloadDir.path, filename, originalExt);
        await audioFile.copy(actualOutputPath);
        if (audioFile.existsSync()) audioFile.deleteSync();
        onProgress(1.0, VideoStatus.finished);
        return actualOutputPath;
      } else {
        throw Exception("No files downloaded");
      }
    }

    return outputPath;
  } catch (e) {
    logger.e("Download process error: $e");
    onProgress(0, VideoStatus.failed);
    for (var file in downloadedFiles.values) {
      if (file.existsSync()) file.deleteSync();
    }
    rethrow;
  } finally {
    dio.close();
  }
}
