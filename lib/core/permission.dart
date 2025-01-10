import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_dl/core/log.dart';

Future<void> requestPermissions(Function callback, {Function? error}) async {
  // Request permissions
  await Permission.storage.request();
  await Permission.manageExternalStorage.request();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();

  // Check individual permissions
  if (statuses[Permission.storage] == PermissionStatus.granted ||
      statuses[Permission.manageExternalStorage] == PermissionStatus.granted) {
    callback();
  } else {
    if (error != null) {
      error();
    } else {
      logger.e("Storage permission check error");
    }
  }
}
