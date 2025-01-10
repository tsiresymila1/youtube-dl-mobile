import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTItem extends StatefulWidget {
  final Video video;

  const YTItem({super.key, required this.video});

  @override
  State<YTItem> createState() => _YTItemState();
}

class _YTItemState extends State<YTItem> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
        initialVideoId: widget.video.id.value,
        flags: const YoutubePlayerFlags(
            autoPlay: false, mute: false, enableCaption: true));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: 160,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: YoutubePlayer(
              bufferIndicator: SizedBox.shrink(),
              showVideoProgressIndicator: false,
              controller: controller,
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                FullScreenButton(),
              ],
            ),
          ),
        ),
        ListTile(
          style: ListTileStyle.list,
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          title: Text(
            "${widget.video.title} - ${widget.video.duration != null ? widget.video.duration!.formatDuration() : ''}",
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          leading: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(widget.video.thumbnails.highResUrl),
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Text(
            widget.video.description.replaceRange(
                min(140, widget.video.description.length), null, '...'),
            style: const TextStyle(fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
