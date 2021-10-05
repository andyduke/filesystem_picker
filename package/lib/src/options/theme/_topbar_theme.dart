import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '_breadcrumbs_theme.dart';

@immutable
class FilesystemPickerTopBarThemeData with Diagnosticable {
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
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
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.breadcrumbsTheme,
  });

  Color? getForegroundColor(BuildContext context, [Color? color]) {
    final effectiveColor = color ??
        foregroundColor ??
        AppBarTheme.of(context).toolbarTextStyle?.color ??
        Theme.of(context).primaryTextTheme.headline6?.color;
    return effectiveColor;
  }

  Color? getBackgroundColor(BuildContext context, [Color? color]) {
    final effectiveColor = color ?? backgroundColor ?? AppBarTheme.of(context).backgroundColor;
    return effectiveColor;
  }

  double? getElevation(BuildContext context) {
    final effectiveElevation = elevation ?? AppBarTheme.of(context).elevation;
    return effectiveElevation;
  }

  Color? getShadowColor(BuildContext context, [Color? color]) {
    final effectiveColor = color ?? shadowColor ?? AppBarTheme.of(context).shadowColor;
    return effectiveColor;
  }

  ShapeBorder? getShape(BuildContext context) {
    final effectiveShape = shape ?? AppBarTheme.of(context).shape;
    return effectiveShape;
  }

  IconThemeData? getIconTheme(BuildContext context) {
    final effectiveIconTheme = iconTheme ?? AppBarTheme.of(context).iconTheme;
    return effectiveIconTheme;
  }

  TextStyle? getTitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle =
        (theme.appBarTheme.titleTextStyle ?? theme.textTheme.headline6?.copyWith(color: foregroundColor) ?? TextStyle())
            .merge(titleTextStyle);
    return effectiveTextStyle;
  }

  SystemUiOverlayStyle? getSystemOverlayStyle(BuildContext context) {
    final effectiveOverlayStyle = systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle;
    return effectiveOverlayStyle;
  }

  BreadcrumbsThemeData? getBreadcrumbsThemeData(BuildContext context) {
    final effectiveThemeData = breadcrumbsTheme ??
        BreadcrumbsThemeData(
          itemColor: foregroundColor,
        );
    return effectiveThemeData;
  }
}
