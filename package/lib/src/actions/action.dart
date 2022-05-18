import 'dart:io';
import 'package:flutter/widgets.dart';

typedef FilesystemPickerActionCallback = Future<bool> Function(BuildContext context, Directory path);

class FilesystemPickerAction {
  final Widget icon;
  final String text;
  final FilesystemPickerActionCallback action;

  FilesystemPickerAction({
    required this.icon,
    required this.text,
    required this.action,
  });
}
