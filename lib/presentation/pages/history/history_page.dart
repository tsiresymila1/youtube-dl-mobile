
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/widgets/history_audio_item.dart';
import 'package:youtube_dl/presentation/widgets/history_item.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 140,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.2,
              title: Text(
                "download_title".tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(20),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              BlocBuilder<HistoryBloc, HistoryState>(
                bloc: sl.get<HistoryBloc>(),
                builder: (context, state) {
                  if (state.videos.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    onPressed: () => _confirmClearHistory(context),
                    icon: const Icon(Icons.delete_sweep_rounded,
                        color: Colors.redAccent),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          BlocBuilder<HistoryBloc, HistoryState>(
            bloc: sl.get<HistoryBloc>(),
            builder: (context, state) {
              if (state.videos.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withAlpha(10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.cloud_off_rounded,
                              size: 64, color: Theme.of(context).colorScheme.primary.withAlpha(100)),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "no_downloads".tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "no_downloads_hint".tr(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.search_rounded),
                          label: Text("go_search".tr()),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final files = state.videos;
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      final historyItem = files[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: historyItem.isMp3
                            ? HistoryAudioItem(video: historyItem)
                            : HistoryItem(video: historyItem),
                      );
                    },
                    childCount: files.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("clear_history_title".tr()),
        content: Text("clear_history_content".tr()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("cancel".tr())),
          FilledButton(
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistoryEvent());
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text("clear_all".tr()),
          ),
        ],
      ),
    );
  }
}
