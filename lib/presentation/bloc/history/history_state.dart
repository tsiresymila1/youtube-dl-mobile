part of 'history_bloc.dart';



sealed class HistoryState {
  final List<VideoItem> videos;
  HistoryState({required this.videos});
}

final class HistoryVideoState extends HistoryState {
  HistoryVideoState({super.videos = const []});
}
