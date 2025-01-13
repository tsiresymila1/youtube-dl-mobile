import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_dl/core/download.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/core/models/video/serializable_video.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/presentation/bloc/history/history_bloc.dart';
import 'package:youtube_dl/service_locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'download_event.dart';

part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial()) {
    on<DownloadVideoInitEvent>((event, emit) async {
      try {
        List<dynamic> futures = event.futures;
        String outputPath = await processDownload(
            futures.map((e) => (e) as Map<String, dynamic>).toList(),
            event.filename,
            event.name,
            event.mp3);
        VideoItem item = VideoItem(
            uuid: Uuid().v4(),
            path: outputPath,
            isMp3: event.mp3,
            video: SerializableVideo.fromVideo(event.video));
        sl.get<HistoryBloc>().add(AddHistoryEvent(
            video: item));
        add(DownloadVideoFinishedEvent(video: item));
      } catch (e) {
        logger.e(e);
      }
    });
    on<DownloadVideoFinishedEvent>((event, emit) {
      emit(DownloadFinished(video: event.video));
    });
  }
}
