import 'dart:io';

class RootInfo {
  final Directory directory;
  final String label;

  String get absolutePath => directory.absolute.path;
  String get path => directory.path;

  RootInfo(this.directory, this.label);

  @override
  bool operator ==(Object other) {
    return other is RootInfo && absolutePath == other.absolutePath;
  }

  @override
  int get hashCode => absolutePath.hashCode;
}