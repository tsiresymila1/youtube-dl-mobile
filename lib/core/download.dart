import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      "-i ${video.path} -i ${audio.path} -c:v libx264 -c:a aac -strict experimental $outputPath";
  await FFmpegKit.execute(command).then((session) async {
    final returnCode = await session.getReturnCode();
    audio.deleteSync();
    video.deleteSync();
    if (!ReturnCode.isSuccess(returnCode)) {
      final logs = await session.getLogsAsString();
      logger.e("Merge failed: $logs");
      Fluttertoast.showToast(
        msg: "Merge video and Audio failed!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  });
}

Future<void> _convertToMp3(File audio, String outputPath) async {
  final command = "-i ${audio.path} -vn -c:a libmp3lame -b:a 192k $outputPath";
  await FFmpegKit.execute(command).then((session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
    } else {
      final logs = await session.getLogsAsString();
      logger.e("Conversion failed: $logs");
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

Future<String> processDownload(
  List<Map<String, dynamic>> futures,
  String filename,
  String name,
  bool mp3,
) async {
  final downloadDir = Directory('/storage/emulated/0/Download');
  if (!downloadDir.existsSync()) {
    downloadDir.createSync(recursive: true);
  }
  // final downloadDir =
  //     await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  logger.i(downloadDir.path);
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
      _getOutputFilepath(downloadDir.path, filename, mp3 ? 'mp3' : "mp4");
  var files = results.where((e) => e != null);
  if (files.length == 2) {
    final audio = files.first!;
    final video = files.last!;
    logger.i("Merging .....");
    Fluttertoast.showToast(
      msg: "Merging video and Audio ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    await _mergeAudioVideo(audio, video, outputPath);
  } else if (files.length == 1) {
    final audio = files.first!;
    logger.i("Creating mp3 file ....");
    Fluttertoast.showToast(
      msg: "Creating mp3 file ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    await _convertToMp3(audio, outputPath);
  }
  logger.i("Finished ....");
  return outputPath;
}
