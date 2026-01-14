import 'dart:async';
import 'dart:ui';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_dl/core/download.dart';
import 'package:youtube_dl/core/models/video_item/video_item.dart';
import 'package:youtube_dl/core/log.dart';
import 'package:youtube_dl/service_locator.dart';


Future<void> initializeBackgroundService() async {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'download_service_channel',
      channelName: 'Download Service',
      channelDescription: 'Handles background downloads',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(DownloadTaskHandler());
}

class DownloadTaskHandler extends TaskHandler {
  final Map<String, String> _activeDownloads = {};
  bool _isInitialized = true;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    DartPluginRegistrant.ensureInitialized();
    await setupDependency();
    _isInitialized = true;

    logger.i('Download Background Service started‡‡');
  }

  void _updateSummary() {
    if (_activeDownloads.isEmpty) {
      FlutterForegroundTask.updateService(
        notificationTitle: "YouDown",
        notificationText: "Service running",
      );
      return;
    }

    final count = _activeDownloads.length;
    final names = _activeDownloads.values.take(2).join(", ");
    final text = count > 2 ? "$names and ${count - 2} more..." : names;

    FlutterForegroundTask.updateService(
      notificationTitle: "Downloading $count items",
      notificationText: text,
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    logger.i('Download Background Service destroyed');
  }

  @override
  void onReceiveData(Object data) async {
    logger.i('Background service received data: $data');
    logger.i('Is initialized : $_isInitialized');
    if (!_isInitialized) {
      // Wait a bit if not initialized yet
      for (int i = 0; i < 5; i++) {
        if (_isInitialized) break;
        await Future.delayed(const Duration(milliseconds: 200));
      }
      if (!_isInitialized) return;
    }
    if (data is Map<String, dynamic>) {
      final String action = data['action'];

      if (action == 'startDownload') {
        final String uuid = data['uuid'];
        logger.i('Starting download for item: $uuid, Name: ${data['name']}');
        final String? videoId = data['videoId'];
        final String filename = data['filename'];
        final String name = data['name'];
        final bool mp3 = data['mp3'];
        final List<Map<String, dynamic>> futures =
            List<Map<String, dynamic>>.from(data['futures']);

        _activeDownloads[uuid] = name;
        _updateSummary();

        final prefs = await SharedPreferences.getInstance();

        try {
          final outputPath = await processDownload(
            futures: futures,
            videoId: videoId,
            filename: filename,
            name: name,
            mp3: mp3,
            onProgress: (progress, status) {
              // Send data to UI
              FlutterForegroundTask.sendDataToMain({
                'type': 'updateProgress',
                'uuid': uuid,
                'progress': progress,
                'status': status.index,
              });

              // Save state for sync
              prefs.setDouble('progress_$uuid', progress);
              prefs.setInt('status_$uuid', status.index);
            },
          );

          _activeDownloads.remove(uuid);
          _updateSummary();

          // Download finished
          FlutterForegroundTask.sendDataToMain({
            'type': 'downloadFinished',
            'uuid': uuid,
            'path': outputPath,
          });

          prefs.setString('path_$uuid', outputPath);
          prefs.setDouble('progress_$uuid', 1.0);
          prefs.setInt('status_$uuid', VideoStatus.finished.index);

        } catch (e) {
          logger.e("Background download error: $e");
          _activeDownloads.remove(uuid);
          _updateSummary();

          FlutterForegroundTask.sendDataToMain({
            'type': 'updateProgress',
            'uuid': uuid,
            'progress': 0.0,
            'status': VideoStatus.failed.index,
          });
          prefs.setInt('status_$uuid', VideoStatus.failed.index);
        }

        // Stop service if no more active downloads
        if (_activeDownloads.isEmpty) {
          // Keep it running for a bit or let user stop it manually?
          // Usually better to let it run until app is closed or explicit stop
        }
      } else if (action == 'stopService') {
        FlutterForegroundTask.stopService();
      }
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }
}

