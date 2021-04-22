import 'dart:math';
import 'package:path/path.dart' as path;

class StorageInfo {
  final String rootDir;
  final String appFilesDir;
  final int availableBytes;
  final String label;

  int get availableGB => availableBytes ~/ pow(2, 30);

  int get availableMB => availableBytes ~/ pow(2, 20);

  StorageInfo(this.appFilesDir, this.availableBytes, this.rootDir, this.label);

  factory StorageInfo.fromJson(Map json, bool isInternal) {
    String storagePath = json['path'];
    int avBytes = json['availableBytes'];
    var root = storagePath
        .split('/')
        .sublist(0, storagePath.split('/').length - 4)
        .join('/');
    var label = isInternal ? 'Internal Storage' : path.basename(root);
    return StorageInfo(storagePath, avBytes, root, label);
  }

//String get rootDir => appFilesDir.split("/").sublist(0,appFilesDir.split("/").length-4).join("/");
//get root with: reply[0]["path"].split("/").sublist(0,reply[0]["path"].split("/").length-4).join("/");
}
