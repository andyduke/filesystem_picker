import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FilesystemPickerFileListThemeData with Diagnosticable {
  final double? iconSize;

  final IconData? upIcon;
  final Color? upIconColor;

  final IconData? folderIcon;
  final Color? folderIconColor;

  final IconData? fileIcon;
  final Color? fileIconColor;

  final IconData? checkIcon;
  final Color? checkIconColor;
  final double? checkIconSize;

  // TODO: Extensions Icons

  FilesystemPickerFileListThemeData({
    this.iconSize,
    this.upIcon,
    this.upIconColor,
    this.folderIcon,
    this.folderIconColor,
    this.fileIcon,
    this.fileIconColor,
    this.checkIcon,
    this.checkIconColor,
    this.checkIconSize,
  });

  FilesystemPickerFileListThemeData resolve(BuildContext context) {
    return FilesystemPickerFileListThemeData(
        // TODO:
        );
  }
}
