import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum FilesystemPickerActionLocation {
  barCenter,
  floatingStart,
  floatingCenter,
  floatingEnd,
}

@immutable
class FilesystemPickerActionThemeData with Diagnosticable {
  static const FilesystemPickerActionLocation defaultLocation = FilesystemPickerActionLocation.barCenter;
  static const double defaultCheckIconSize = 24;

  final FilesystemPickerActionLocation location;

  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  final TextStyle? textStyle;

  final IconData? checkIcon;
  final Color? checkIconColor;
  final double? checkIconSize;

  FilesystemPickerActionThemeData({
    this.location = defaultLocation,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.textStyle,
    this.checkIcon,
    this.checkIconColor,
    this.checkIconSize,
  });

  Color? getForegroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? foregroundColor ?? Theme.of(context).colorScheme.onBackground;
    return effectiveValue;
  }

  Color? getDisabledForegroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? disabledForegroundColor ?? getForegroundColor(context)?.withOpacity(0.6);
    return effectiveValue;
  }

  Color getBackgroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? backgroundColor ?? Theme.of(context).primaryColor;
    return effectiveValue;
  }

  double? getElevation(BuildContext context) {
    final effectiveValue = elevation;
    return effectiveValue;
  }

  ShapeBorder? getShape(BuildContext context) {
    final effectiveShape = shape ?? AppBarTheme.of(context).shape;
    return effectiveShape;
  }

  TextStyle? getTextStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    final effectiveTextStyle = (theme.textTheme.bodyText1 ?? TextStyle()).copyWith(color: color).merge(textStyle);
    return effectiveTextStyle;
  }

  IconData getCheckIcon(BuildContext context) {
    final effectiveValue =
        checkIcon ?? ((location == FilesystemPickerActionLocation.barCenter) ? Icons.check_circle : Icons.check);
    return effectiveValue;
  }

  IconThemeData getCheckIconTheme(BuildContext context) {
    return IconThemeData(
      color: checkIconColor ?? getForegroundColor(context),
      size: checkIconSize ?? defaultCheckIconSize,
    );
  }

  FloatingActionButtonLocation? getFloatingButtonLocation(BuildContext context) {
    switch (location) {
      case FilesystemPickerActionLocation.barCenter:
        return null;

      case FilesystemPickerActionLocation.floatingStart:
        return FloatingActionButtonLocation.startFloat;

      case FilesystemPickerActionLocation.floatingCenter:
        return FloatingActionButtonLocation.centerFloat;

      case FilesystemPickerActionLocation.floatingEnd:
        return FloatingActionButtonLocation.endFloat;
    }
  }

  bool get isBarMode => location == FilesystemPickerActionLocation.barCenter;

  bool get isFABMode => location != FilesystemPickerActionLocation.barCenter;
}
