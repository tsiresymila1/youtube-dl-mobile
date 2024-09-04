import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(Function callback, {Function? error}) async {
  // Request permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    if (await Permission.manageExternalStorage.isDenied)
      Permission.manageExternalStorage,
  ].request();
  // Check individual permissions
  if (statuses[Permission.storage] != PermissionStatus.denied ||
      statuses[Permission.manageExternalStorage] != PermissionStatus.denied) {
    callback();
  }else{
    if(error != null){
      error();
    }
  }
}