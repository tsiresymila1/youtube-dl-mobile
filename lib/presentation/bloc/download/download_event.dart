part of 'download_bloc.dart';

@immutable
sealed class DownloadEvent {}

final class DownloadVideoInitEvent extends DownloadEvent {
  final List<Map<String, dynamic>> futures;
  final String filename;
  final String name;
  final bool mp3;
  final Video video;

  DownloadVideoInitEvent(
      {required this.futures,
      required this.filename,
      required this.name,
      required this.mp3,
      required this.video});
}

final class DownloadVideoDownloadingEvent extends DownloadEvent {
  final Uuid uuid;

  DownloadVideoDownloadingEvent({required this.uuid});
}

final class DownloadVideoFinishedEvent extends DownloadEvent {
  final Video video;

  DownloadVideoFinishedEvent({required this.video});
}
