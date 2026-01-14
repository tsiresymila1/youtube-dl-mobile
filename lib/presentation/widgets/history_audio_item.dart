import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryAudioItem extends StatefulWidget {
  final VideoItem video;

  const HistoryAudioItem({super.key, required this.video});

  @override
  State<HistoryAudioItem> createState() => _HistoryAudioItemState();
}

class _HistoryAudioItemState extends State<HistoryAudioItem>
    with WidgetsBindingObserver {
  final player = AudioPlayer();
  Duration? duration;
  Duration? position;
  bool isPlaying = false;
  bool isLoading = true;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    if (widget.video.status == VideoStatus.finished && widget.video.path.isNotEmpty) {
      _initializePlayer();
    }
  }

  @override
  void didUpdateWidget(HistoryAudioItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.status != widget.video.status &&
        widget.video.status == VideoStatus.finished &&
        widget.video.path.isNotEmpty) {
      _initializePlayer();
    }
  }

  void _initializePlayer() {
    if(File(widget.video.path).existsSync()) {
    player.setFilePath(widget.video.path).then((d) {
      if (!mounted) return;
      setState(() {
        duration = d;
        isLoading = false;
      });
      player.playbackEventStream.listen((event) {
        if (!isDragging && mounted) {
          setState(() {
            position = event.updatePosition;
          });
        }
      });
    });
    player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
    player.positionStream.listen((event) {
      if (!mounted) return;
      if (event == duration) {
        player.stop();
        player.seek(Duration());
        setState(() {
          position = Duration();
        });
      } else {
        setState(() {
          position = event;
        });
      }
    });
  }
}

  @override
  void dispose() {
    player.dispose();
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
    final isFinished = widget.video.status == VideoStatus.finished;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildAlbumArt(isFinished, theme),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFinished
                            ? widget.video.video.author
                            : _getStatusText(widget.video.status),
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: isFinished
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.primary,
                              fontWeight:
                                  isFinished ? null : FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                _buildActions(context, theme),
              ],
            ),
            if (isFinished) ...[
              const SizedBox(height: 12),
              _buildPlayerControls(theme),
            ] else ...[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: widget.video.progress,
                  minHeight: 8,
                  backgroundColor: colorScheme.onSurface.withAlpha(20),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getStatusText(widget.video.status),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "${(widget.video.progress * 100).toInt()}%",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText(VideoStatus status) {
    switch (status) {
      case VideoStatus.downloading:
        return "downloading".tr();
      case VideoStatus.merging:
        return "merging".tr();
      case VideoStatus.converting:
        return "converting".tr();
      case VideoStatus.finished:
        return "finished".tr();
      case VideoStatus.failed:
        return "failed".tr();
    }
  }

  Widget _buildAlbumArt(bool isFinished, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(widget.video.video.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: isFinished
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: widget.video.status == VideoStatus.failed
                    ? Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 24)
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ),
    );
  }

  Widget _buildPlayerControls(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        height: 40,
        child: Center(child: LinearProgressIndicator(minHeight: 2)),
      );
    }
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.onSurface.withAlpha(30),
            thumbColor: colorScheme.primary,
          ),
          child: Slider(
            value: min(duration?.inMilliseconds ?? 0, position?.inMilliseconds ?? 0).toDouble(),
            min: 0.0,
            max: (duration?.inMilliseconds ?? 1).toDouble(),
            onChanged: (value) {
              setState(() {
                isDragging = true;
                position = Duration(milliseconds: value.toInt());
              });
            },
            onChangeEnd: (value) {
              setState(() => isDragging = false);
              _seekTo(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position?.formatDuration() ?? '0:00',
                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                duration?.formatDuration() ?? '0:00',
                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    final isFinished = widget.video.status == VideoStatus.finished;
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFinished)
          IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.folder_open_rounded, size: 18, color: colorScheme.onSurfaceVariant),
            onPressed: () {
              openFileManager(
                androidConfig: AndroidConfig(folderType: AndroidFolderType.download),
              );
            },
          ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error, size: 18),
          onPressed: () => _confirmDelete(context, theme),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("delete_audio_title".tr()),
        content: Text("delete_audio_content".tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("cancel".tr())),
          FilledButton(
            onPressed: () {
              context.read<HistoryBloc>().add(RemoveHistoryEvent(uuid: widget.video.uuid));
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: Text("delete".tr()),
          ),
        ],
      ),
    );
  }
}
