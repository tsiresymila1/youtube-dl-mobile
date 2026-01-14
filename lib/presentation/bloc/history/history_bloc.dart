import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends HydratedBloc<HistoryEvent, HistoryState> {

  HistoryBloc() : super(HistoryVideoState()) {
    on<AddHistoryEvent>((event, emit) {
      emit(HistoryVideoState(videos: [event.video, ...state.videos]));
    });
    on<RemoveHistoryEvent>((event, emit) {
      emit(HistoryVideoState(
          videos: state.videos.where((f) => f.uuid != event.uuid).toList()));
    });
    on<UpdateHistoryEvent>((event, emit) {
      final updatedVideos = state.videos.map((v) {
        return v.uuid == event.video.uuid ? event.video : v;
      }).toList();
      emit(HistoryVideoState(videos: updatedVideos));
    });
    on<ClearHistoryEvent>((event, emit) {
      emit(HistoryVideoState(videos: []));
    });
  }

  @override
  HistoryState? fromJson(Map<String, dynamic> json) {
    return HistoryVideoState(
        videos: (json["data"] as List).map((f) {
      final map = f as Map<String, dynamic>;
      return VideoItem.fromJson(map);
    }).toList());
  }

  @override
  Map<String, dynamic>? toJson(HistoryState state) {
    return {
      "data": state.videos.map((r) => r.toJson()).toList()
    };
  }
}
