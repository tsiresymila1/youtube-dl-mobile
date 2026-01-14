import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YTItem extends StatefulWidget {
  final Video video;

  const YTItem({super.key, required this.video});

  @override
  State<YTItem> createState() => _YTItemState();
}

class _YTItemState extends State<YTItem> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocBuilder<HistoryBloc, HistoryState>(
        buildWhen: (previous, current) {
          final wasDownloading = previous.videos.any((v) =>
              v.video.id.value == widget.video.id.value &&
              v.status != VideoStatus.finished &&
              v.status != VideoStatus.failed);
          final isDownloading = current.videos.any((v) =>
              v.video.id.value == widget.video.id.value &&
              v.status != VideoStatus.finished &&
              v.status != VideoStatus.failed);
          return wasDownloading != isDownloading;
        },
        builder: (context, state) {
          final isDownloading = state.videos.any((v) =>
              v.video.id.value == widget.video.id.value &&
              v.status != VideoStatus.finished &&
              v.status != VideoStatus.failed);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                if (isDownloading) {
                  context.goNamed("history");
                } else {
                  context.pushNamed("view", extra: {"video": widget.video});
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(Theme.of(context).brightness == Brightness.dark ? 50 : 10),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              widget.video.thumbnails.mediumResUrl,
                              fit: BoxFit.cover,
                              cacheWidth: (MediaQuery.of(context).size.width *
                                      MediaQuery.of(context).devicePixelRatio).toInt(),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                      child: Icon(Icons.error_outline_rounded, color: Colors.grey)),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.withAlpha(20),
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withAlpha(200),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        if (widget.video.duration != null)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(180),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withAlpha(50), width: 0.5),
                              ),
                              child: Text(
                                widget.video.duration!.formatDuration(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary.withAlpha(30),
                            backgroundImage: widget.video.thumbnails.lowResUrl.isNotEmpty
                                ? NetworkImage(widget.video.thumbnails.lowResUrl)
                                : null,
                            child: widget.video.thumbnails.lowResUrl.isEmpty
                                ? Text(widget.video.author[0].toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.video.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${widget.video.author} • ${widget.video.engagement.viewCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${"views".tr()}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildDownloadButton(context, isDownloading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, bool isDownloading) {
    if (isDownloading) {
      return Container(
        height: 36,
        width: 36,
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: _handleDownload,
        icon: Icon(
          Icons.arrow_downward_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }

  void _handleDownload() {
    final loaderBloc = context.read<LoaderBloc>();
    loaderBloc.add(LoaderEventLoading());
    sl.get<YoutubeExplode>().videos.streams.getManifest(widget.video.id,
        ytClients: [
          YoutubeApiClient.android,
          YoutubeApiClient.ios,
          YoutubeApiClient.safari,
          YoutubeApiClient.androidVr
        ]).then((manifest) async {
      if (mounted) {
        await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) {
              return YtModalSheetQualitySelector(
                manifest: manifest,
                video: widget.video,
              );
            });
      }
    }).catchError((err) {
      logger.e(err.toString());
      if (mounted) {
        AwesomeDialog(
          context: context,
          animType: AnimType.bottomSlide,
          dialogType: DialogType.noHeader,
          title: "error_occurred".tr(),
          desc: err.toString(),
          btnCancelOnPress: () {
            loaderBloc.add(LoaderEventStop());
          },
        ).show();
      }
    }).whenComplete(() {
      loaderBloc.add(LoaderEventStop());
    });
  }
}
