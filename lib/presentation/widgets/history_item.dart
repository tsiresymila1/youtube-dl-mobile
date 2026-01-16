import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HistoryItem extends StatefulWidget {
  final VideoItem video;

  const HistoryItem({super.key, required this.video});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.video.status == VideoStatus.finished && widget.video.path.isNotEmpty) {
      _initializePlayer(autoPlay: false);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    chewieController?.pause();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HistoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.status != widget.video.status &&
        widget.video.status == VideoStatus.finished &&
        widget.video.path.isNotEmpty) {
      _initializePlayer(autoPlay: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDownloading = widget.video.status != VideoStatus.finished;
    final isDeleted = !File(widget.video.path).existsSync();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: isDeleted 
            ? BorderSide(color: colorScheme.error.withValues(alpha: 0.5), width: 1)
            : BorderSide.none,
      ),
      color: theme.cardColor,
      child: InkWell(
        onTap: isDownloading || isDeleted
            ? null
            : () {
                if (chewieController == null) {
                  _initializePlayer();
                }
              },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (chewieController != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Chewie(controller: chewieController!),
                    )
                  else ...[
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        widget.video.video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => Container(
                          color: colorScheme.onSurface.withAlpha(20),
                          child: Icon(Icons.video_library_rounded, size: 48, color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                    if (widget.video.status == VideoStatus.failed)
                      Container(
                        color: Colors.black.withAlpha(180),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                "failed".tr().toUpperCase(),
                                style: TextStyle(
                                  color: colorScheme.errorContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (isDownloading)
                      Container(
                        color: Colors.black.withAlpha(150),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                CircularProgressIndicator(
                                  value: widget.video.progress,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getStatusText(widget.video.status),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${(widget.video.progress * 100).toInt()}%",
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    else if (isDeleted)
                      Container(
                        color: Colors.black.withAlpha(150),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_sweep_rounded, color: colorScheme.error, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                "file_removed".tr().toUpperCase(),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.errorContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(200),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.play_arrow_rounded, color: colorScheme.onPrimary, size: 32),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.video.video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildActions(context, theme),
                    ],
                  ),
                ],
              ),
            ),
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

  Widget _buildActions(BuildContext context, ThemeData theme) {
    final isFinished = widget.video.status == VideoStatus.finished;
    final isDeleted = !File(widget.video.path).existsSync();
    final colorScheme = theme.colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFinished && !isDeleted) ...[
          IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              openFileManager(
                androidConfig: AndroidConfig(folderType: AndroidFolderType.other, folderPath: "/storage/emulated/0/Download/Youdown"),
              );
            },
            icon: Icon(Icons.folder_open_rounded, size: 18, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 4),
        ],
        if (widget.video.status == VideoStatus.failed || isDeleted)
          IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            onPressed: () => _handleRetry(),
            icon: Icon(Icons.refresh_rounded, color: colorScheme.primary, size: 18),
          ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          visualDensity: VisualDensity.compact,
          onPressed: () => _confirmDelete(context, theme),
          icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error, size: 18),
        ),
      ],
    );
  }

  void _initializePlayer({bool autoPlay = true}) {
    if (!File(widget.video.path).existsSync()) return;
    
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(File(widget.video.path));
    
    _videoPlayerController?.addListener(() {
      if (!mounted || _videoPlayerController == null) return;
      final value = _videoPlayerController!.value;
      if (value.isInitialized && 
          !value.isPlaying && 
          value.position >= value.duration && 
          value.duration != Duration.zero) {
        _videoPlayerController!.seekTo(Duration.zero);
        _videoPlayerController!.pause();
      }
    });

    _videoPlayerController?.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        chewieController = ChewieController(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          videoPlayerController: _videoPlayerController!,
          autoPlay: autoPlay,
          looping: false,
          allowFullScreen: true,
          showControls: true,
          showControlsOnInitialize: false,
          materialProgressColors: ChewieProgressColors(
            playedColor: Theme.of(context).colorScheme.primary,
            handleColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white24,
            bufferedColor: Colors.white38,
          ),
        );
      });
    });
  }

  void _confirmDelete(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("delete_video_title".tr()),
        content: Text("delete_video_content".tr()),
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

  Future<void> _handleRetry() async {
    final loaderBloc = context.read<LoaderBloc>();
    loaderBloc.add(LoaderEventLoading());
    final yt = sl.get<YoutubeExplode>();

    // Use the video ID from the saved video item
    final videoId = widget.video.video.id;

    try {
      final video = await yt.videos.get(videoId);
      final manifest = await yt.videos.streams.getManifest(video.id);

      if (!mounted) return;

      // If we are retrying, we might want to suggest the same options or just let user pick again.
      // Showing the quality selector is the safest bet to get a fresh download URL.
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => YtModalSheetQualitySelector(
          manifest: manifest,
          video: video,
        ),
      );

      loaderBloc.add(LoaderEventStop());
    } catch (e) {
      if (!mounted) return;
      _handleError(context, e.toString(), loaderBloc);
    }
  }

  void _handleError(BuildContext context, String error, LoaderBloc loaderBloc) {
    logger.e(error);
    if (!mounted) return;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      title: "error_occurred".tr(),
      desc: error,
      btnOkOnPress: () {},
      btnOkColor: Colors.redAccent,
      useRootNavigator: true,
    ).show().then((_) {
      loaderBloc.add(LoaderEventStop());
    });
  }
}
