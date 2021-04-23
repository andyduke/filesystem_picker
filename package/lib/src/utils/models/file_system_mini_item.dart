import 'dart:io';

class FileSystemMiniItem {
  final String absolutePath;
  final FileSystemEntityType type;

  FileSystemMiniItem(this.absolutePath, this.type);
}
