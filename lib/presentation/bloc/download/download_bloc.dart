import 'package:bloc/bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_dl/core/background_service.dart';
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
      final uuid = const Uuid().v4();
      final videoMeta = SerializableVideo.fromVideo(event.video);
      
      // Initialize item in history immediately
      VideoItem item = VideoItem(
        uuid: uuid,
        path: "", // Path will be updated later
        isMp3: event.mp3,
        video: videoMeta,
        status: VideoStatus.downloading,
        progress: 0.0,
      );
      sl.get<HistoryBloc>().add(AddHistoryEvent(video: item));

      try {
        final isRunning = await FlutterForegroundTask.isRunningService;
        if (!isRunning) {
          await FlutterForegroundTask.startService(
            notificationTitle: 'Downloading Video...',
            notificationText: 'Preparing...',
            callback: startCallback,
          );
        }

        FlutterForegroundTask.sendDataToTask({
          'action': 'startDownload',
          'uuid': uuid,
          'videoId': event.video.id.value,
          'futures': event.futures,
          'filename': event.filename,
          'name': event.name,
          'mp3': event.mp3,
        });

        Fluttertoast.showToast(
          msg: "Download started: ${event.video.title}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

      } catch (e) {
        logger.e(e);
        item = item.copyWith(status: VideoStatus.failed);
        sl.get<HistoryBloc>().add(UpdateHistoryEvent(video: item));
      }
    });
    on<DownloadVideoFinishedEvent>((event, emit) {
      emit(DownloadFinished(video: event.video));
    });
  }
}
