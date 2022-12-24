import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FilesystemShortcut with Diagnosticable {
  final String name;
  final IconData? icon;
  final Directory path;

  FilesystemShortcut({
    required this.name,
    this.icon,
    required this.path,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(DiagnosticsProperty<Directory>('path', path));
  }
}
