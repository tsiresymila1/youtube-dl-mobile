import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/core/models/video/serializable_video.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/core/permission.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtModalSheetQualitySelector extends StatefulWidget {
  final StreamManifest manifest;
  final Video video;

  const YtModalSheetQualitySelector(
      {super.key, required this.manifest, required this.video});

  @override
  State<YtModalSheetQualitySelector> createState() =>
      _YtModalSheetQualitySelectorState();
}

class _YtModalSheetQualitySelectorState
    extends State<YtModalSheetQualitySelector> {
  late StreamInfo info;
  bool mp3 = false;

  @override
  void initState() {
    info = widget.manifest.video.first;
    super.initState();
  }

  _getOutputFilepath(String parent, String filename, String ext) {
    String outputPath = "$parent/$filename.$ext";
    int counter = 0;
    while (File(outputPath).existsSync()) {
      counter++;
      outputPath = "$parent/$filename($counter).$ext";
    }
    return outputPath;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Video Quality',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const Gap(16.0),
            DropdownButton<StreamInfo>(
              value: info,
              items: [...widget.manifest.video].map((quality) {
                return DropdownMenuItem<StreamInfo>(
                  value: quality,
                  child: Row(
                    children: [
                      Text(
                          "${quality.tag} -${quality.qualityLabel} - ${quality.videoResolution} - ${quality.size.totalMegaBytes.toStringAsFixed(1)} Mo"),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (StreamInfo? newValue) {
                if (newValue != null) {
                  setState(() {
                    info = newValue;
                  });
                }
              },
            ),
            const Gap(24.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Switch(
            //       value: mp3,
            //       activeColor: Colors.red,
            //       onChanged: (bool value) {
            //         setState(() {
            //           mp3 = value;
            //         });
            //       },
            //     ),
            //     const Gap(12),
            //     const Text("Only mp3")
            //   ],
            // ),
            // const Gap(24.0),
            ElevatedButton(
              onPressed: () async {
                final historyBloc = context.read<HistoryBloc>();
                Navigator.of(context, rootNavigator: true).pop();
                final filename = widget.video.title
                    .split(" ")
                    .join("_")
                    .replaceAll(RegExp(r'[^\w\s]', multiLine: true), '');
                FileDownloader.setLogEnabled(false);
                Fluttertoast.showToast(
                    msg: "Starting download ...",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 14.0);
                final audioOnly = widget.manifest.audio.firstWhere((q) => q.container.name.toLowerCase() == "mp4");
                final audioUrl = audioOnly.url
                    .toString();
                logger.i(audioUrl);
                final futures = [
                  FileDownloader.downloadFile(
                      url: audioUrl,
                      name:
                          "Youtube_DL_Audio_$filename.${audioOnly.container.name}",
                      notificationType: mp3
                          ? NotificationType.all
                          : NotificationType.disabled,
                      downloadDestination: DownloadDestinations.appFiles,
                      onDownloadError: (error) {
                        logger.e(error, error: error);
                      }),
                ];
                if (!mp3) {
                  futures.add(FileDownloader.downloadFile(
                      url: info.url.toString(),
                      name: "$filename.${info.container.name}",
                      notificationType: NotificationType.all,
                      downloadDestination: DownloadDestinations.appFiles,
                      onDownloadError: (error) {
                        logger.e(error, error: error);
                      }));
                }
                await requestPermissions(() {
                  Future.wait(eagerError: true, futures).then((value) async {
                    final files = value.where((v) => v != null);
                    final downloadDir =
                        Directory("/storage/emulated/0/Downloads/YoutubeDL");
                    if (!downloadDir.existsSync()) {
                      downloadDir.createSync(recursive: true);
                    }
                    final outputPath = _getOutputFilepath(
                        downloadDir.path, filename,mp3 ? 'mp3': info.container.name);
                    if (files.length == 2) {
                      final audio = files.firstWhere((f) =>
                          f != null && f.path.contains("Youtube_DL_Audio_"));
                      final video = files.firstWhere((f) =>
                          f != null && !f.path.contains("Youtube_DL_Audio_"));
                      logger.i(outputPath);
                      Fluttertoast.showToast(
                          msg: "Merging video and Audio at $outputPath...",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.greenAccent.shade100,
                          fontSize: 14.0);
                      FFmpegKit.execute(
                              '-i ${video?.path} -i ${audio?.path}  -c:v copy -c:a aac -strict experimental -shortest $outputPath -y')
                          .then((session) async {
                        logger.i(outputPath);
                        final returnCode = await session.getReturnCode();
                        if (ReturnCode.isSuccess(returnCode)) {
                          Fluttertoast.showToast(
                              msg:
                                  "Video downloaded successfully at $outputPath.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.greenAccent.shade100,
                              fontSize: 14.0);
                          historyBloc.add(AddHistoryEvent(
                              video: VideoItem(
                                  uuid: const Uuid().v4(),
                                  path: outputPath,
                                  video: SerializableVideo.fromVideo(
                                      widget.video))));
                        } else if (ReturnCode.isCancel(returnCode)) {
                          logger.w("Video execution cancelled");
                          Fluttertoast.showToast(
                              msg: "Video downloaded cancelled",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        } else {
                          final error = await session.getAllLogsAsString();
                          logger.e(
                            error,
                            error: error,
                          );
                          Fluttertoast.showToast(
                              msg: error ?? '',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                        await video?.delete();
                        await audio?.delete();
                      });
                    } else {
                      logger.i(files);
                      final audio = files.first;
                      FFmpegKit.execute("-codecs").then((s)async {
                        logger.w(await s.getAllLogsAsString());
                      });
                      FFmpegKit.execute(
                              "-i ${audio?.path} -c:a aac -strict experimental -shortest -b:a 192k $outputPath -y")
                          .then((session) async {
                        logger.i(session.getCommand());
                        final returnCode = await session.getReturnCode();
                        if (ReturnCode.isSuccess(returnCode)) {
                          Fluttertoast.showToast(
                              msg:
                                  "MP3 downloaded successfully at $outputPath.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.greenAccent.shade100,
                              fontSize: 14.0);
                          historyBloc.add(AddHistoryEvent(
                              video: VideoItem(
                                  isMp3: true,
                                  uuid: const Uuid().v4(),
                                  path: outputPath,
                                  video: SerializableVideo.fromVideo(
                                      widget.video))));
                        } else if (ReturnCode.isCancel(returnCode)) {
                          logger.w("MP3 converting cancelled");
                          Fluttertoast.showToast(
                              msg: "MP3 downloaded cancelled",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        } else {
                          final error = await session.getAllLogsAsString();
                          logger.e(
                            error,
                            error: error,
                          );
                          Fluttertoast.showToast(
                              msg: error ?? '',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                        await audio?.delete();
                      });
                    }
                  }).catchError((e) {
                    logger.e(error: e, e.toString());
                    Fluttertoast.showToast(
                        msg: e.toString(),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  });
                }, error: () {
                  AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.noHeader,
                          title: "Error",
                          desc: "Check permission to write",
                          descTextStyle: const TextStyle(color: Colors.red),
                          btnCancelColor: Colors.redAccent,
                          btnCancelIcon: Icons.close,
                          btnCancelText: "Close",
                          useRootNavigator: true,
                          btnCancelOnPress: () {})
                      .show();
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
