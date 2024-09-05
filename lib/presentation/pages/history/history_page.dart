import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/presentation/widgets/history_audio_item.dart';
import 'package:youtube_dl/presentation/widgets/history_item.dart';
import 'package:youtube_dl/service_locator.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Downloads", style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        elevation: 4,
        scrolledUnderElevation: 4,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        bloc: sl.get<HistoryBloc>(),
        builder: (context, state) {
          return Visibility(
            visible: state.videos.isNotEmpty,
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
            child: ListView.builder(
                itemCount: state.videos.length,
                itemBuilder: (ctx, index) {
                  final historyItem = state.videos[index];
                  return historyItem.isMp3
                      ? HistoryAudioItem(video: historyItem)
                      : HistoryItem(
                          video: historyItem,
                        );
                }),
          );
        },
      ),
    );
  }
}
