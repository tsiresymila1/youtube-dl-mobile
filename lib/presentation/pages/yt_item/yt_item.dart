import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_item.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/presentation/widgets/yt_shimmer_item.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class YtItemView extends StatefulWidget {
  final Video video;

  const YtItemView({super.key, required this.video});

  @override
  State<YtItemView> createState() => _YtItemViewState();
}

class _YtItemViewState extends State<YtItemView> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;
  bool showFullDescription = false;
  bool _isPlayerReady = false;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id.value,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (mounted && _controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
    ));
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isDark = Theme.of(context).brightness == Brightness.dark;
    final isDark = _isDark;
    
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: YoutubePlayerBuilder(
          onExitFullScreen: () {
            setState(() => isFullScreen = false);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            ));
          },
          onEnterFullScreen: () => setState(() => isFullScreen = true),
          player: YoutubePlayer(
            controller: _controller,
            key: ObjectKey(widget.video.id),
            bufferIndicator: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            showVideoProgressIndicator: false,
            progressColors: ProgressBarColors(
              playedColor: Theme.of(context).primaryColor,
              handleColor: Theme.of(context).primaryColor,
            ),
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
            },
            topActions: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    if (isFullScreen) {
                      _controller.toggleFullScreenMode();
                    }
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
          builder: (context, player) {
            return Column(
              children: [
                RepaintBoundary(
                  child: player,
                ),
                if (!isFullScreen)
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.video.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "${widget.video.engagement.viewCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${"views".tr()} • ${widget.video.uploadDate != null ? "${widget.video.uploadDate!.day}/${widget.video.uploadDate!.month}/${widget.video.uploadDate!.year}" : ""}",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                            widget.video.thumbnails.mediumResUrl),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          widget.video.author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton.filledTonal(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: widget.video.url));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Link copied to clipboard")),
                                          );
                                        },
                                        icon: const Icon(Icons.share_rounded, size: 20),
                                        tooltip: "share".tr(),
                                      ),
                                      const SizedBox(width: 8),
                                        FilledButton.icon(
                                          onPressed: () {
                                            final loaderBloc =
                                                context.read<LoaderBloc>();
                                            loaderBloc.add(LoaderEventLoading());
                                            sl
                                                .get<YoutubeExplode>()
                                                .videos
                                                .streamsClient
                                                .getManifest(widget.video.id)
                                                .then((manifest) {
                                              if (!context.mounted) return;

                                            loaderBloc.add(LoaderEventStop());
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (ctx) {
                                                    return YtModalSheetQualitySelector(
                                                      manifest: manifest,
                                                      video: widget.video,
                                                    );
                                                  });
                                            }).catchError((err) {
                                              if (!context.mounted) return;
                                              loaderBloc.add(LoaderEventStop());
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.error,
                                                title: "error_occurred".tr(),
                                                desc: err.toString(),
                                              ).show();
                                            });
                                          },
                                          icon: const Icon(Icons.download_rounded, size: 20),
                                          label: Text("download".tr()),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  InkWell(
                                    onTap: () => setState(() =>
                                        showFullDescription =
                                            !showFullDescription),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outline.withAlpha(20),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "description".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.video.description,
                                            maxLines: showFullDescription ? null : 3,
                                            overflow: showFullDescription
                                                ? TextOverflow.visible
                                                : TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            (showFullDescription ? "show_less" : "show_more").tr(),
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                Text(
                                  "related_videos".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        QueryBuilder("get-related-${widget.video.id}", () async {
                          return await sl
                              .get<YoutubeExplode>()
                              .videos
                              .getRelatedVideos(widget.video);
                        }, builder: (context, query) {
                          if (query.isLoading) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => const YTShimmerItem(),
                                childCount: 5,
                              ),
                            );
                          }
                          if (query.hasError) {
                            return SliverFillRemaining(
                              child: Center(
                                child: ElevatedButton.icon(
                                    onPressed: () => query.refresh(),
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: Text("reload".tr())),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final v = query.data![index];
                                return YTItem(
                                  key: ValueKey(v.id.value),
                                  video: v,
                                );
                              },
                              childCount: query.data?.length ?? 0,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: true,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

