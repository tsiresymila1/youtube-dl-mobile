import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_dl/core/log.dart';

Future<void> requestPermissions(Function callback, {Function? error}) async {
  bool isGranted = false;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      // Android 11+ (includes 12, 13, 14, 15, 16)
      // We need MANAGE_EXTERNAL_STORAGE for direct file write access (FFmpeg, etc.)
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
      isGranted = status.isGranted;
    } else {
      // Android 10 and below
      var status = await Permission.storage.request();
      isGranted = status.isGranted;
    }
  } else {
    // iOS and others
    var status = await Permission.storage.request();
    isGranted = status.isGranted;
  }

  if (isGranted) {
    callback();
  } else {
    if (error != null) {
      error();
    } else {
      logger.e("Storage permission check error");
    }
  }
}
