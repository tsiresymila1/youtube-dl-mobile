import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';

class HistoryAudioItem extends StatefulWidget {
  final VideoItem video;

  const HistoryAudioItem({super.key, required this.video});

  @override
  State<HistoryAudioItem> createState() => _HistoryAudioItemState();
}

class _HistoryAudioItemState extends State<HistoryAudioItem> with WidgetsBindingObserver {
  final player = AudioPlayer();
  Duration? duration;
  Duration? position;
  bool isPlaying = false;
  bool isLoading = true;
  bool isDragging = false;
  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.video.path).then((d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
      player.playbackEventStream.listen((event) {
        if (!isDragging) {
          setState(() {
            position = event.updatePosition;
          });
        }
      });
    });
    player.playerStateStream.listen((state) {
      if (state.playing != isPlaying) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
    player.positionStream.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    setState(() {
      position = null;
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.stop();
    }
  }

  void _togglePlayPause() {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
  }

  void _seekTo(Duration newPosition) {
    player.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 140,
              child: Visibility(
                visible: !isLoading,
                replacement: const Center(
                  child: SpinKitThreeBounce(
                    size: 40,
                    color: Colors.redAccent,
                  ),
                ),
                child: Column(
                  children: [
                    // Play/Pause Button
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    // Progress Bar
                    Slider(
                      value: min(duration?.inMilliseconds ?? 0, position?.inMilliseconds ?? 0).toDouble(),
                      min: 0.0,
                      max: (duration?.inMilliseconds  ?? 1).toDouble(),
                      onChanged: (value) {
                        setState(() {
                          isDragging = true;
                          position = Duration(milliseconds: min(duration?.inMilliseconds ?? 1,value.toInt()));
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          isDragging = false;
                        });
                        _seekTo(Duration(milliseconds: min(duration?.inMilliseconds ?? 1,value.toInt())));
                      },
                    ),
                    // Display time
                    Text(
                      "${position?.toString().split('.').first ?? '00:00:00'} / ${duration?.toString().split('.').first ?? '00:00:00'}",
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              )),
          ListTile(
            style: ListTileStyle.list,
            dense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            title: Text(
              "${widget.video.video.title} - ${widget.video.video.duration != null ? widget.video.video.duration?.formatDuration() : ''}",
              style:
              const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.folder),
                  onPressed: () {
                    openFileManager(
                      androidConfig:
                          AndroidConfig(folderType: FolderType.recent),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    final historyBloc = context.read<HistoryBloc>();
                    historyBloc
                        .add(RemoveHistoryEvent(uuid: widget.video.uuid));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0).copyWith(bottom: 12),
            child: Text(
              widget.video.video.description.replaceRange(
                  min(140, widget.video.video.description.length), null, '...'),
              style: const TextStyle(fontSize: 12.0),
            ),
          )
        ],
      ),
    );
  }
}
