import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '_breadcrumbs_theme.dart';

@immutable
class FilesystemPickerTopBarThemeData with Diagnosticable {
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final BreadcrumbsThemeData? breadcrumbsTheme;

  FilesystemPickerTopBarThemeData({
    this.foregroundColor,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.iconTheme,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.breadcrumbsTheme,
  });

  FilesystemPickerTopBarThemeData resolve(BuildContext context) {
    return FilesystemPickerTopBarThemeData(
        // TODO:
        );
  }
}
