import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '_breadcrumbs_theme.dart';

/// Defines a theme for the [AppBar] widget used in the picker.
///
/// Here you can set the color and style of the header, close button and breadcrumbs.
///
/// See also:
/// * [AppBar] for additional description of visual parameters.
@immutable
class FilesystemPickerTopBarThemeData with Diagnosticable {
  /// The default color for Text and Icons within the app bar.
  final Color? foregroundColor;

  /// The fill color to use for an app bar's [Material].
  final Color? backgroundColor;

  /// The z-coordinate at which to place this app bar relative to its parent.
  final double? elevation;

  /// The color of the shadow below the app bar.
  final Color? shadowColor;

  /// The shape of the app bar's [Material] as well as its shadow.
  final ShapeBorder? shape;

  /// The color, opacity, and size to use for toolbar icons.
  final IconThemeData? iconTheme;

  /// The default text style for the AppBar's title widget.
  final TextStyle? titleTextStyle;

  /// Specifies the style to use for the system overlays that overlap the [AppBar].
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Specifies the theme for the breadcrumbs used in the picker.
  final BreadcrumbsThemeData? breadcrumbsTheme;

  /// {@macro flutter.material.appbar.scrolledUnderElevation}
  final double? scrolledUnderElevation;

  /// Creates a theme that can be used in [FilesystemPickerTheme] and [Breadcrumbs].
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
    this.scrolledUnderElevation,
  });

  /// Returns the default color for Text and Icons within the app bar.
  ///
  /// If no value is set in the theme, then the [foregroundColor] from the
  /// current [AppBarTheme] or color of [onPrimary] from [colorScheme] is returned
  /// (the app theme is taken from the `context`).
  Color? getForegroundColor(BuildContext context, [Color? color]) {
    Color? effectiveColor;

    final theme = Theme.of(context);
    if (theme.useMaterial3) {
      effectiveColor = color ??
          foregroundColor ??
          theme.appBarTheme.foregroundColor ??
          theme.colorScheme.onSurface;
    } else {
      effectiveColor = color ??
          foregroundColor ??
          theme.appBarTheme.foregroundColor ??
          theme.colorScheme.onPrimary;
    }

    return effectiveColor;
  }

  /// Returns the fill color to use for an app bar's [Material].
  ///
  /// If no value is set in the theme, then the [backgroundColor] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  Color? getBackgroundColor(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);

    final effectiveColor = color ??
        backgroundColor ??
        AppBarTheme.of(context).backgroundColor ??
        (theme.useMaterial3
            ? theme.colorScheme.surface
            : theme.colorScheme.primary);
    return effectiveColor;
  }

  /// Returns the z-coordinate at which to place this app bar relative to its parent.
  ///
  /// If no value is set in the theme, then the [elevation] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  double? getElevation(BuildContext context) {
    final effectiveElevation = elevation ?? AppBarTheme.of(context).elevation;
    return effectiveElevation;
  }

  /// Returns the color of the shadow below the app bar.
  ///
  /// If no value is set in the theme, then the [shadowColor] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  Color? getShadowColor(BuildContext context, [Color? color]) {
    final effectiveColor =
        color ?? shadowColor ?? AppBarTheme.of(context).shadowColor;
    return effectiveColor;
  }

  /// Returns the shape of the app bar's [Material] as well as its shadow.
  ///
  /// If no value is set in the theme, then the [shape] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  ShapeBorder? getShape(BuildContext context) {
    final effectiveShape = shape ?? AppBarTheme.of(context).shape;
    return effectiveShape;
  }

  /// Returns the [IconThemeData] to use for toolbar icons.
  ///
  /// If no value is set in the theme, then the [iconTheme] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  IconThemeData? getIconTheme(BuildContext context) {
    final effectiveIconTheme = iconTheme ?? AppBarTheme.of(context).iconTheme;
    return effectiveIconTheme;
  }

  /// Returns the default text style for the AppBar's title widget.
  ///
  /// If no value is set in the theme, then the [titleTextStyle] from the
  /// current [AppBarTheme] or [titleLarge] from [textTheme] is returned
  /// (the app theme is taken from the `context`).
  TextStyle? getTitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = (theme.appBarTheme.titleTextStyle ??
            theme.textTheme.titleLarge?.copyWith(color: foregroundColor) ??
            const TextStyle())
        .merge(titleTextStyle);
    return effectiveTextStyle;
  }

  /// Returns the style to use for the system overlays that overlap the [AppBar].
  ///
  /// If no value is set in the theme, then the [systemOverlayStyle] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  SystemUiOverlayStyle? getSystemOverlayStyle(BuildContext context) {
    final effectiveOverlayStyle =
        systemOverlayStyle ?? AppBarTheme.of(context).systemOverlayStyle;
    return effectiveOverlayStyle;
  }

  /// Returns the [BreadcrumbsThemeData] to use for breadcrumbs.
  BreadcrumbsThemeData? getBreadcrumbsThemeData(BuildContext context) {
    final effectiveThemeData = breadcrumbsTheme ??
        BreadcrumbsThemeData(
          itemColor: foregroundColor,
        );
    return effectiveThemeData;
  }

  /// Returns the `scrolledUnderElevation` value.
  ///
  /// If no value is set in the theme, then the [scrolledUnderElevation] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  double? getScrolledUnderElevation(BuildContext context) {
    final effectiveScrolledUnderElevation = scrolledUnderElevation ??
        AppBarTheme.of(context).scrolledUnderElevation;
    return effectiveScrolledUnderElevation;
  }

  /// Returns a new picker topbar theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerTopBarThemeData merge(FilesystemPickerTopBarThemeData base) {
    return FilesystemPickerTopBarThemeData(
      foregroundColor: foregroundColor ?? base.foregroundColor,
      backgroundColor: backgroundColor ?? base.backgroundColor,
      elevation: elevation ?? base.elevation,
      shadowColor: shadowColor ?? base.shadowColor,
      shape: shape ?? base.shape,
      iconTheme: iconTheme?.merge(base.iconTheme) ?? base.iconTheme,
      titleTextStyle:
          base.titleTextStyle?.merge(titleTextStyle) ?? titleTextStyle,
      systemOverlayStyle: systemOverlayStyle ?? base.systemOverlayStyle,
      breadcrumbsTheme: breadcrumbsTheme?.merge(base.breadcrumbsTheme) ??
          base.breadcrumbsTheme,
      scrolledUnderElevation:
          scrolledUnderElevation ?? base.scrolledUnderElevation,
    );
  }
}
