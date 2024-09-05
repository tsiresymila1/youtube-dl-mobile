import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_dl/core/extensions/duration.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTItem extends StatelessWidget {
  final Video video;

  const YTItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
            ),
            child: YoutubePlayer(
              progressIndicatorColor: Colors.redAccent,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                controller: YoutubePlayerController(
                    initialVideoId: video.id.value,
                    flags: const YoutubePlayerFlags(autoPlay: false, mute: false))),
          ),
        ),
        ListTile(
          style: ListTileStyle.list,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          title: Text(
            "${video.title} - ${video.duration != null ? video.duration!.formatDuration() : ''}",
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          leading: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(video.thumbnails.highResUrl),
          ),
          trailing: IconButton(
            onPressed: () {
              final loaderBloc = context.read<LoaderBloc>();
              loaderBloc.add(LoaderEventLoading());
              sl
                  .get<YoutubeExplode>()
                  .videos
                  .streamsClient
                  .getManifest(video.id, fullManifest: true)
                  .then((manifest) {
                Navigator.of(context, rootNavigator: true).pop();
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return YtModalSheetQualitySelector(
                        manifest: manifest,
                        video: video,
                      );
                    });
              }).catchError((_) {
                loaderBloc.add(LoaderEventStop());
              });
            },
            icon: const Icon(
              Icons.download,
              color: Colors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 4),
          child: Text(
            video.description
                .replaceRange(min(140, video.description.length), null, '...'),
            style: const TextStyle(fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
