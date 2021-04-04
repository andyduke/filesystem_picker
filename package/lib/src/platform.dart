import 'dart:math';
import 'package:path/path.dart' as Path;
import 'package:flutter/services.dart';

class PlatformMethods {
  static const platform = const MethodChannel(
      'filesystem_picker/android_native');

  static Future<bool> isStorageAcessAllowed() async {
    try {
      final bool result = await platform.invokeMethod(
          'isExternalStorageManager');
      return result;
    } on PlatformException catch (e) {
      print("Oh no...\n\n" + e.message!);
    }

    return false;
  }

  static Future<List<StorageInfo>> getStorageInfo() async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
          'getExtStorageData');

      bool internalFirst = true; // first StorageInfo should be Internal
      List<StorageInfo> storageInfos = result.map<StorageInfo>((
          storageInfoMap) {
        var si = StorageInfo.fromJson(storageInfoMap, internalFirst);
        internalFirst = false;
        return si;
      }).toList();

      return storageInfos;
    } on PlatformException catch (e) {
      print("Oh no...\n\n" + e.message!);
    }

    return [];
  }
}

class StorageInfo {
  final String rootDir;
  final String appFilesDir;
  final int availableBytes;
  final String label;

  int get availableGB => availableBytes ~/ pow(2, 30);

  int get availableMB => availableBytes ~/ pow(2, 20);

  StorageInfo(this.appFilesDir, this.availableBytes, this.rootDir, this.label);

  factory StorageInfo.fromJson(Map json, bool isInternal) {
    String path = json["path"];
    int avBytes = json["availableBytes"];
    var root = path.split("/").sublist(0, path
        .split("/")
        .length - 4).join("/");
    var label = isInternal ? "Internal Storage" : Path.basename(root);
    return StorageInfo(path, avBytes, root, label);
  }

//String get rootDir => appFilesDir.split("/").sublist(0,appFilesDir.split("/").length-4).join("/");
//get root with: reply[0]["path"].split("/").sublist(0,reply[0]["path"].split("/").length-4).join("/");
}