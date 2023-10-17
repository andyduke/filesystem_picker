import 'dart:io';
import 'package:filesystem_picker/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Shortcut - a specific path of the file system, it can be the root of a disk,
/// a user folder, a folder with a photo, etc.
///
/// You can set a name for it to be displayed in the FilesystemPicker,
/// as well as specify whether it can be selected in the picker.
class FilesystemPickerShortcut with Diagnosticable {
  /// The name of the shortcut displayed in the picker.
  final String name;

  /// Shortcut icon, if not specified, the icon from the theme will be displayed.
  final IconData? icon;

  /// File system path.
  final Directory path;

  /// Specify whether this shortcut can be selected as the resulting path in the picker.
  final bool isSelectable;

  /// Creates a shortcut.
  FilesystemPickerShortcut({
    required this.name,
    this.icon,
    required Directory path,
    this.isSelectable = true,
  }) : path = normalizeRootPath(path);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(DiagnosticsProperty<Directory>('path', path));
    properties.add(DiagnosticsProperty<bool>('isSelectable', isSelectable));
  }
}
