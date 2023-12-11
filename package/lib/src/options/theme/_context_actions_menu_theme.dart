import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the theme for the actions popup menu.
@immutable
class FilesystemPickerContextActionsMenuThemeData with Diagnosticable {
  /// The theme for the menu item icon.
  final IconThemeData? iconTheme;

  /// The text style for the menu item.
  final TextStyle? textStyle;

  /// The elevation of the popup menu.
  final double? elevation;

  /// The shape of the popup menu.
  final ShapeBorder? shape;

  /// The color of the popup menu icon and text.
  final Color? foregroundColor;

  /// The color of the background selection of the popup menu item.
  final Color? highlightBackgroundColor;

  /// The background color of the popup menu.
  final Color? backgroundColor;

  /// Creates a theme for the actions popup menu.
  const FilesystemPickerContextActionsMenuThemeData({
    this.iconTheme,
    this.textStyle,
    this.elevation,
    this.shape,
    this.foregroundColor,
    this.highlightBackgroundColor,
    this.backgroundColor,
  });

  Color? getForegroundColor(BuildContext context) {
    final effectiveColor = foregroundColor ??
        Theme.of(context).popupMenuTheme.textStyle?.color ??
        Theme.of(context).textTheme.bodyMedium?.color;
    return effectiveColor;
  }

  /// Returns the theme for the menu item icon.
  IconThemeData getIconTheme(BuildContext context) {
    final effectiveValue = const IconThemeData()
        .copyWith(color: getForegroundColor(context))
        .merge(iconTheme);
    return effectiveValue;
  }

  /// Returns the text style for the menu item.
  TextStyle getTextStyle(BuildContext context) {
    final effectiveValue = const TextStyle()
        .copyWith(color: getForegroundColor(context))
        .merge(textStyle);
    return effectiveValue;
  }

  /// Returns the elevation of the popup menu.
  double? getElevation(BuildContext context) {
    return elevation;
  }

  /// Returns the shape of the popup menu.
  ShapeBorder? getShape(BuildContext context) {
    return shape;
  }

  /// Returns the color of the background selection of the popup menu item.
  Color? getHighlightBackgroundColor(BuildContext context) {
    return highlightBackgroundColor;
  }

  /// Returns the background color of the popup menu.
  Color? getBackgroundColor(BuildContext context) {
    return backgroundColor;
  }

  /// Returns a new context actions menu theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsMenuThemeData merge(
      FilesystemPickerContextActionsMenuThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsMenuThemeData(
      iconTheme: iconTheme?.merge(base.iconTheme) ?? base.iconTheme,
      textStyle: textStyle?.merge(base.textStyle) ?? base.textStyle,
      elevation: elevation ?? base.elevation,
      shape: shape ?? base.shape,
      foregroundColor: foregroundColor ?? base.foregroundColor,
      highlightBackgroundColor:
          highlightBackgroundColor ?? base.highlightBackgroundColor,
      backgroundColor: backgroundColor ?? base.backgroundColor,
    );
  }
}
