import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FilesystemPickerContextActionsMenuThemeData with Diagnosticable {
  final IconThemeData? iconTheme;
  final TextStyle? textStyle;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? foregroundColor;
  final Color? highlightBackgroundColor;
  final Color? backgroundColor;

  const FilesystemPickerContextActionsMenuThemeData({
    this.iconTheme,
    this.textStyle,
    this.elevation,
    this.shape,
    this.foregroundColor,
    this.highlightBackgroundColor,
    this.backgroundColor,
  });

  IconThemeData getIconTheme(BuildContext context) {
    final effectiveValue = IconThemeData().copyWith(color: foregroundColor).merge(iconTheme);
    return effectiveValue;
  }

  TextStyle getTextStyle(BuildContext context) {
    final effectiveValue = TextStyle().copyWith(color: foregroundColor).merge(textStyle);
    return effectiveValue;
  }

  double? getElevation(BuildContext context) {
    return elevation;
  }

  ShapeBorder? getShape(BuildContext context) {
    return shape;
  }

  Color? getSelectedBackgroundColor(BuildContext context) {
    return highlightBackgroundColor;
  }

  Color? getBackgroundColor(BuildContext context) {
    return backgroundColor;
  }

  /// Returns a new context actions menu theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsMenuThemeData merge(FilesystemPickerContextActionsMenuThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsMenuThemeData(
      iconTheme: iconTheme?.merge(base.iconTheme) ?? base.iconTheme,
      textStyle: textStyle?.merge(base.textStyle) ?? base.textStyle,
      elevation: elevation ?? base.elevation,
      shape: shape ?? base.shape,
      foregroundColor: foregroundColor ?? base.foregroundColor,
      highlightBackgroundColor: highlightBackgroundColor ?? base.highlightBackgroundColor,
      backgroundColor: backgroundColor ?? base.backgroundColor,
    );
  }
}
