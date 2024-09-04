import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtModalDownloadLink extends StatefulWidget {
  const YtModalDownloadLink({super.key});

  @override
  State<YtModalDownloadLink> createState() => _YtModalDownloadLinkState();
}

class _YtModalDownloadLinkState extends State<YtModalDownloadLink> {
  String videoId = '';
  TextEditingController c = TextEditingController();

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
                  'Download video',
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
            TextFormField(
              keyboardType: TextInputType.url,
              controller: c,
              onChanged: (value) {
                setState(() {
                  videoId = value;
                  c.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'https://www.youtube.com/watch?v=-Xd251j9mgM',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Gap(24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final RegExp youtubeRegex = RegExp(
                      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$|^[a-zA-Z0-9_-]{11}$',
                      caseSensitive: false,
                    );
                    if (youtubeRegex.hasMatch(videoId) && videoId != '') {
                      final loaderBloc = context.read<LoaderBloc>();
                      loaderBloc.add(LoaderEventLoading());
                      final yt = sl.get<YoutubeExplode>();
                      yt.videos.get(videoId).then((video) {
                        yt.videos.streamsClient
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
                          AwesomeDialog(
                                  context: context,
                                  animType: AnimType.bottomSlide,
                                  dialogType: DialogType.noHeader,
                                  title: "Error",
                                  desc: _.toString(),
                                  btnCancelColor: Colors.redAccent,
                                  btnCancelIcon: Icons.close,
                                  btnCancelText: "Close",
                                  useRootNavigator: true,
                                  btnCancelOnPress: () {})
                              .show()
                              .then((_) {
                            loaderBloc.add(LoaderEventStop());
                          });
                        });
                      }).catchError((_) async {
                        AwesomeDialog(
                                context: context,
                                animType: AnimType.bottomSlide,
                                dialogType: DialogType.noHeader,
                                title: "Error",
                                desc: _.toString(),
                                btnCancelColor: Colors.redAccent,
                                btnCancelIcon: Icons.close,
                                btnCancelText: "Close",
                                useRootNavigator: true,
                                btnCancelOnPress: () {})
                            .show()
                            .then((_) {
                          loaderBloc.add(LoaderEventStop());
                        });
                        // loaderBloc.add(LoaderEventStop());
                      });
                    } else {
                      logger.e("Error");
                      // Navigator.of(context).pop();
                      AwesomeDialog(
                              context: context,
                              animType: AnimType.bottomSlide,
                              dialogType: DialogType.noHeader,
                              title: "Error",
                              desc: "Link or ID not valid",
                              btnCancelColor: Colors.redAccent,
                              btnCancelIcon: Icons.close,
                              btnCancelText: "Close",
                              useRootNavigator: true,
                              btnCancelOnPress: () {})
                          .show();
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
