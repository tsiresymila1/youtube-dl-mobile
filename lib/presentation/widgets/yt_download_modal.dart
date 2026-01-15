import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/presentation/bloc/loader/loader_bloc.dart';
import 'package:youtube_dl/presentation/widgets/yt_modal_sheet.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:easy_localization/easy_localization.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32), 
          bottom: Radius.circular(32)
          ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.link_rounded, color: Colors.redAccent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'paste_link'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'enter_url'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.url,
            controller: c,
            autofocus: true,
            style: const TextStyle(fontSize: 15),
            onChanged: (value) => setState(() => videoId = value),
            decoration: InputDecoration(
              hintText: 'https://youtube.com/watch?v=...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: videoId.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        c.clear();
                        setState(() => videoId = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: videoId.isEmpty ? null : () => _handleConfirm(context),
              icon: const Icon(Icons.analytics_rounded),
              label: Text(
                'start_download'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleConfirm(BuildContext context) {
    final RegExp youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$|^[a-zA-Z0-9_-]{11}$',
      caseSensitive: false,
    );
    
    if (youtubeRegex.hasMatch(videoId) && videoId.isNotEmpty) {
      final loaderBloc = context.read<LoaderBloc>();
      loaderBloc.add(LoaderEventLoading());
      final yt = sl.get<YoutubeExplode>();

      yt.videos.get(videoId).then((video) async {
        yt.videos.streams.getManifest(video.id).then((manifest) async {
          if (!context.mounted) return;
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
          if (!context.mounted) return;
          context.pop();
        }).catchError((e) {
          if (!context.mounted) return;
          _handleError(context, e.toString(), loaderBloc);
        });
      }).catchError((e) {
        if (!context.mounted) return;
        _handleError(context, e.toString(), loaderBloc);
      });
    } else {
      _showValidationError(context);
    }
  }

  void _handleError(BuildContext context, String error, LoaderBloc loaderBloc) {

    if (!context.mounted) return;
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

  void _showValidationError(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      title: "invalid_url".tr(),
      desc: "invalid_url".tr(),
      btnOkOnPress: () {},
      btnOkColor: Colors.orange,
      useRootNavigator: true,
    ).show();
  }
}
