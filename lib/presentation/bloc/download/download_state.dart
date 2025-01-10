part of 'download_bloc.dart';

@immutable
sealed class DownloadState {}

final class DownloadInitial extends DownloadState {}

final class DownloadFinished extends DownloadState{
  final Video video;
  DownloadFinished({required this.video});
}
