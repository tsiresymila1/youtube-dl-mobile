import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return MutationBuilder<VideoSearchList, dynamic, String, dynamic>(
        "search-key", (keyword) async {
      return await sl.get<YoutubeExplode>().search.search(keyword);
    }, builder: (context, mutation) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle,
                color: Colors.redAccent,
                size: 40,
              ),
              Gap(20),
              Text("Youtube DL"),
            ],
          ),
          elevation: 4,
          scrolledUnderElevation: 4,
          actions: [
            IconButton(
                onPressed: () {
                  context.goNamed('history');
                },
                icon: const Icon(Icons.cloud_download)),
            IconButton(
                onPressed: () {
                  context.goNamed('about');
                },
                icon: const Icon(Icons.info))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)
                      .copyWith(bottom: 16),
              child: TextField(
                autofocus: false,
                onSubmitted: (keyword) {
                  if (keyword.trim().isNotEmpty) {
                    mutation.mutate(keyword);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Visibility(
            visible: mutation.isMutating,
            replacement: Visibility(
              visible: mutation.hasData && mutation.data!.isNotEmpty,
              replacement: Visibility(
                visible: mutation.hasError,
                replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/nodata.png"),
                      const Gap(20),
                      const Text("No data")
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    mutation.error.toString().contains("SocketException")
                        ? "Check your internet connection!!"
                        : mutation.error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              child: ListView.builder(
                  itemCount: mutation.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final video = mutation.data![index];
                    return Card(
                      child: YTItem(video: video),
                    );
                  }),
            ),
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const YTShimmerItem();
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.download_for_offline_outlined,
            color: Colors.redAccent,
          ),
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const Dialog(child: YtModalDownloadLink());
                });
          },
        ),
      );
    });
  }
}
