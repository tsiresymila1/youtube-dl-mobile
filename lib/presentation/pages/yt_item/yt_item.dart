import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_item.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YtItemView extends StatefulWidget {
  final YoutubePlayerController controller;
  final Video video;

  const YtItemView({super.key, required this.controller, required this.video});

  @override
  State<YtItemView> createState() => _YtItemViewState();
}

class _YtItemViewState extends State<YtItemView> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          YoutubePlayerBuilder(
              onExitFullScreen: () {
                setState(() {
                  isFullScreen = false;
                });
              },
              onEnterFullScreen: () {
                setState(() {
                  isFullScreen = true;
                });
              },
              player: YoutubePlayer(
                controller: widget.controller,
                key: ObjectKey(widget.video.id),
                bufferIndicator: SizedBox.shrink(),
                showVideoProgressIndicator: false,
                topActions: [BackButton()],
                bottomActions: [
                  CurrentPosition(),
                  SizedBox(width: 10),
                  RemainingDuration(),
                  SizedBox(width: 10),
                  ProgressBar(isExpanded: true),
                  SizedBox(width: 10),
                  FullScreenButton(
                    controller: widget.controller,
                  ),
                ],
              ),
              builder: (context, player) {
                return player;
              }),
          Visibility(
            visible: !isFullScreen,
            child: Expanded(
              child: Column(
                children: [
                  ListTile(
                    style: ListTileStyle.list,
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    title: Text(
                      "${widget.video.title} - ${widget.video.duration != null ? widget.video.duration!.formatDuration() : ''}",
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(widget.video.thumbnails.highResUrl),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        final loaderBloc = context.read<LoaderBloc>();
                        loaderBloc.add(LoaderEventLoading());
                        sl
                            .get<YoutubeExplode>()
                            .videos
                            .streamsClient
                            .getManifest(widget.video.id, fullManifest: true)
                            .then((manifest) {
                          Navigator.of(context, rootNavigator: true).pop();
                          showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return YtModalSheetQualitySelector(
                                  manifest: manifest,
                                  video: widget.video,
                                );
                              });
                        }).catchError((err) {
                          logger.i(widget.video.url);
                          logger.e(err.toString());
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.bottomSlide,
                            dialogType: DialogType.noHeader,
                            dismissOnBackKeyPress: false,
                            dismissOnTouchOutside: false,
                            title: "Error",
                            desc: err.toString(),
                            btnCancelOnPress: () {
                              loaderBloc.add(LoaderEventStop());
                            },
                          ).show();
                        });
                      },
                      icon: const Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Text(
                      widget.video.description,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                      child: QueryBuilder("get-related-${widget.video.id}",
                          () async {
                    return await sl
                        .get<YoutubeExplode>()
                        .videos
                        .getRelatedVideos(widget.video);
                  }, builder: (context, query) {
                    if (query.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (query.hasError) {
                      return Center(
                        child: ElevatedButton(
                            onPressed: () {
                              query.refresh();
                            },
                            child: Text("Reload")),
                      );
                    }
                    return ListView.builder(
                        itemCount: query.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final v = query.data![index];
                          return YTItem(video: v);
                        });
                  }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
