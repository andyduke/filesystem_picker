import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FilesystemPickerActionThemeData with Diagnosticable {
  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  final IconData? checkIcon;
  final Color? checkIconColor;
  final double? checkIconSize;

  FilesystemPickerActionThemeData({
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.checkIcon,
    this.checkIconColor,
    this.checkIconSize,
  });

  FilesystemPickerActionThemeData resolve(BuildContext context) {
    return FilesystemPickerActionThemeData(
        // TODO:
        );
  }
}
