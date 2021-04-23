import 'dart:io';

typedef ValueSelected = void Function(String value, bool isSelected, FileSystemEntityType type);
typedef RequestPermission = Future<bool> Function();