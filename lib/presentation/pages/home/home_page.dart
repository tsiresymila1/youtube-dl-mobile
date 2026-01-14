import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/presentation/widgets/yt_download_modal.dart';
import 'package:youtube_dl/presentation/widgets/yt_item.dart';
import 'package:youtube_dl/presentation/widgets/yt_shimmer_item.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MutationBuilder<VideoSearchList, dynamic, String, dynamic>(
      "search-key",
      (keyword) async {
        return await sl.get<YoutubeExplode>().search.search(keyword);
      },
      builder: (context, mutation) {
        return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const Dialog(
                    backgroundColor: Colors.transparent,
                    child: YtModalDownloadLink(),
                  ),
                );
              },
              label: Text("paste_link".tr()),
              icon: const Icon(Icons.link_rounded),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 64, 20, 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary.withAlpha(40),
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(50),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon( Icons.play_arrow_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "YouDown",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1,
                                    ),
                              ),
                              Text(
                                "ready_to_download".tr(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    titleSpacing: 0,
                    centerTitle: false,
                    scrolledUnderElevation: 0,
                    surfaceTintColor: Colors.transparent,
                    toolbarHeight: 50,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (keyword) {
                          if (keyword.trim().isNotEmpty) {
                            mutation.mutate(keyword);
                          }
                        },
                        decoration: InputDecoration(
                              hintText: 'search_hint'.tr(),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 22),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded,
                                          size: 18),
                                      onPressed: () {
                                        searchController.clear();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ),
                      ),
                    
                    actions: [
                      _buildAppBarAction(
                        context,
                        icon: Icons.cloud_download_rounded,
                        onPressed: () => context.goNamed('history'),
                      ),
                      _buildAppBarAction(
                        context,
                        icon: Icons.settings_rounded,
                        onPressed: () => context.goNamed('settings'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  if (mutation.isMutating)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const YTShimmerItem(),
                        childCount: 5,
                      ),
                    )
                  else if (mutation.hasData && mutation.data!.isNotEmpty)
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final video = mutation.data![index];
                        return YTItem(video: video, key: ValueKey(video.id));
                      },
                      childCount: mutation.data?.length ?? 0,
                    ))
                  else if (mutation.hasError)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wifi_off_rounded,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.outline),
                              const SizedBox(height: 16),
                              Text(
                                mutation.error
                                        .toString()
                                        .contains("SocketException")
                                    ? "no_internet".tr()
                                    : "error_occurred".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mutation.error.toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: () =>
                                    mutation.mutate(searchController.text),
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text("try_again".tr()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.search_rounded,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(150)),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "ready_to_download".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "search_prompt".tr(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildAppBarAction(BuildContext context,
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

