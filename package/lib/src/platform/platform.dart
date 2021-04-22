import 'package:filesystem_picker/src/utils/models/storage_info.dart';
import 'package:flutter/services.dart';

import '../utils/models/storage_info.dart';

class PlatformMethods {
  static const platform = MethodChannel('filesystem_picker/android_native');

  static Future<bool> isStorageAccessAllowed() async {
    try {
      final bool result =
          await platform.invokeMethod('isExternalStorageManager');
      return result;
    } on PlatformException catch (e) {
      print('Oh no...\n\n' + e.message!);
    }
    return false;
  }

  static Future<List<StorageInfo>> getStorageInfo() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('getExtStorageData');
      var internalFirst = true; // first StorageInfo should be Internal
      return result.map<StorageInfo>((storageInfoMap) {
        var si = StorageInfo.fromJson(storageInfoMap, internalFirst);
        internalFirst = false;
        return si;
      }).toList();
    } on PlatformException catch (e) {
      print('Oh no...\n\n' + e.message!);
    }
    return [];
  }
}
