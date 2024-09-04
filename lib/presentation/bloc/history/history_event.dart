part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

final class AddHistoryEvent extends HistoryEvent{
  final VideoItem video;
  AddHistoryEvent({required this.video});
}

final class RemoveHistoryEvent extends HistoryEvent{
  final String uuid;
  RemoveHistoryEvent({required this.uuid});
}
