import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:youtube_dl/core/models/video/serializable_video.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';

part 'history_event.dart';

part 'history_state.dart';

class HistoryBloc extends HydratedBloc<HistoryEvent, HistoryState> {

  HistoryBloc() : super(HistoryVideoState()) {
    on<AddHistoryEvent>((event, emit) {
      emit(HistoryVideoState(videos: [event.video,...state.videos]));
    });
    on<RemoveHistoryEvent>((event, emit) {
      emit(HistoryVideoState(
          videos: state.videos.where((f) => f.uuid != event.uuid).toList()));
    });
  }

  @override
  HistoryState? fromJson(Map<String, dynamic> json) {
    return HistoryVideoState(
        videos: (json["data"] as List<Map<String, dynamic>>).map((f) => VideoItem(
            path: f["path"],
            uuid: f["uuid"], video: SerializableVideo.fromJson(f["video"]))).toList());
  }

  @override
  Map<String, dynamic>? toJson(HistoryState state) {
    return {
      "data":
          state.videos.map((r) => {"uuid": r.uuid, "video": r.video.toJson(), "path": r.path}).toList()
    };
  }
}
