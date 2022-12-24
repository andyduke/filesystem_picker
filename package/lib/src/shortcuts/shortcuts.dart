import 'dart:io';
import 'package:flutter/widgets.dart';

class FilesystemShortcut {
  final String name;
  final IconData? icon;
  final Directory path;

  FilesystemShortcut({
    required this.name,
    this.icon,
    required this.path,
  });
}
