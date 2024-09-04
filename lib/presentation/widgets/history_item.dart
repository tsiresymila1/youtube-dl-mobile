import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';

class HistoryItem extends StatefulWidget {
  final VideoItem video;

  const HistoryItem({super.key, required this.video});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.video.path));
    videoPlayerController.initialize().then((_) {
      chewieController = ChewieController(
        aspectRatio: videoPlayerController.value.aspectRatio,
        videoPlayerController: videoPlayerController,
        autoInitialize: true,
        allowFullScreen: true,
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: chewieController != null,
            replacement: const SizedBox(
              height: 250,
              child: Center(
                child: SizedBox(
                    height: 80,
                    child: SpinKitThreeBounce(
                      color: Colors.redAccent,
                    )),
              ),
            ),
            child: chewieController == null
                ? const SizedBox.shrink()
                : AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                          width: videoPlayerController.value.size.width ?? 0,
                          height: videoPlayerController.value.size.height ?? 0,
                          child: Chewie(
                            controller: chewieController!,
                          )),
                    ),
                  ),
          ),
          ListTile(
            title: Text(
                "${widget.video.video.title} -  ${widget.video.video.duration != null ? widget.video.video.duration?.formatDuration() : ''}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    openFileManager(
                        androidConfig:
                            AndroidConfig(folderType: FolderType.recent));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    final historyBloc = context.read<HistoryBloc>();
                    historyBloc.add(RemoveHistoryEvent(uuid: widget.video.uuid));
                  },
                ),
              ],
            ),
          ),
          ListTile(
            subtitle: Text(
              widget.video.video.description.replaceRange(
                  min(140, widget.video.video.description.length), null, '...'),
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
