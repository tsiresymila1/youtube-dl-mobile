import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'log.dart';

String _getOutputFilepath(String parent, String filename, String ext) {
  String outputPath = "$parent/$filename.$ext";
  int counter = 0;
  while (File(outputPath).existsSync()) {
    counter++;
    outputPath = "$parent/$filename($counter).$ext";
  }
  return outputPath;
}

Future<void> _mergeAudioVideo(File audio, File video, String outputPath) async {
  final command =
      "-i ${video.path} -i ${audio.path} -c:v copy -c:a aac $outputPath";
  await FFmpegKit.execute(command).then((session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      audio.deleteSync();
      video.deleteSync();
    } else {
      logger.e("Merge failed");
    }
  });
}

Future<void> _convertToMp3(File audio, String outputPath) async {
  final command = "-i ${audio.path} -q:a 0 -map a $outputPath";
  await FFmpegKit.execute(command).then((session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
    } else {
      logger.e("Conversion failed");
    }
  });
}

Future<String> processDownload(
  List<Map<String, dynamic>> futures,
  String filename,
  String name,
  bool mp3,
) async {
  final downloadDir =
      await getDownloadsDirectory() ?? await getApplicationCacheDirectory();
  final downloadFutures = futures.map((item) {
    return FileDownloader.downloadFile(
        url: item['url'],
        name: "${item['name']}",
        downloadDestination: DownloadDestinations.appFiles,
        notificationType: item['notificationType'] == "ALL"
            ? NotificationType.all
            : NotificationType.disabled);
  }).toList();
  final results = (await Future.wait(downloadFutures));
  final outputPath =
      _getOutputFilepath(downloadDir.path, filename, mp3 ? 'mp3' : name);
  var files = results.where((e) => e != null);
  if (files.length == 2) {
    final audio = files.first!;
    final video = files.last!;
    logger.i("Merging .....");
    await _mergeAudioVideo(audio, video, outputPath);
  } else if (files.length == 1) {
    final audio = files.first!;
    logger.i("Creating mp3 file ....");
    await _convertToMp3(audio, outputPath);
  }
  logger.i("Finished ....");
  return outputPath;
}
