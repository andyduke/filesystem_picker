import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the type and location of the folder selection action button.
enum FilesystemPickerActionLocation {
  /// In the bottom bar, the button is centered, occupying the entire width of the bar.
  barCenter,

  /// Floating button, in the bottom left corner of the picker.
  floatingStart,

  /// Floating button, in the center at the bottom of the picker.
  floatingCenter,

  /// Floating button, in the bottom right corner of the picker.
  floatingEnd,
}

/// Defines the theme for the folder selection button used in the picker.
///
/// Here you can customize the location and appearance of the button - color, shape, icon, etc.
@immutable
class FilesystemPickerActionThemeData with Diagnosticable {
  /// The default type and location of the button.
  static const FilesystemPickerActionLocation defaultLocation =
      FilesystemPickerActionLocation.barCenter;

  /// The default icon size.
  static const double defaultCheckIconSize = 24;

  /// Returns the current type and location of the button.
  FilesystemPickerActionLocation get location => _location ?? defaultLocation;
  final FilesystemPickerActionLocation? _location;

  /// The color of the icon and the text in the button.
  final Color? foregroundColor;

  /// The color of the icon and the text in the button in the disabled state.
  final Color? disabledForegroundColor;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this button relative to its parent.
  /// See also [FloatingActionButton.elevation].
  final double? elevation;

  /// The shape of the button's [Material].
  ///
  /// The button's highlight and splash are clipped to this shape.
  /// If the button has an elevation, then its drop shadow is defined by this shape as well.
  final ShapeBorder? shape;

  /// The style to use for the text in the button.
  final TextStyle? textStyle;

  /// The icon to display in the button.
  final IconData? checkIcon;

  /// The color of the icon in the button. Overrides the [foregroundColor] value.
  final Color? checkIconColor;

  /// The size of the icon in the button.
  final double? checkIconSize;

  /// Creates a theme that can be used in [FilesystemPickerTheme].
  FilesystemPickerActionThemeData({
    FilesystemPickerActionLocation? location,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.textStyle,
    this.checkIcon,
    this.checkIconColor,
    this.checkIconSize,
  }) : _location = location;

  /// Returns the foreground color that is used for the text and icon in the button,
  /// if no color is set for the icon in the checkIconColor parameter.
  ///
  /// If no value is set in the theme, then the [colorScheme.onBackground] from the
  /// current [Theme] is returned (the app theme is taken from the `context`).
  Color? getForegroundColor(BuildContext context, [Color? color]) {
    final effectiveValue =
        color ?? foregroundColor ?? Theme.of(context).colorScheme.onBackground;
    return effectiveValue;
  }

  /// Returns the foreground color, for the button in the disabled state.
  ///
  /// If no value is set in the theme, the [foregroundColor] is returned with opacity 0.6
  /// (the app theme is taken from the `context`).
  Color? getDisabledForegroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ??
        disabledForegroundColor ??
        getForegroundColor(context)?.withOpacity(0.6);
    return effectiveValue;
  }

  /// Returns the background color of the button.
  ///
  /// If no value is set in the theme, then the [primaryColor] from the
  /// current [Theme] is returned (the app theme is taken from the `context`).
  Color getBackgroundColor(BuildContext context, [Color? color]) {
    Color? effectiveValue;
    final theme = Theme.of(context);
    if (theme.useMaterial3) {
      effectiveValue = color ?? backgroundColor ?? theme.colorScheme.background;
    } else {
      effectiveValue = color ?? backgroundColor ?? theme.primaryColor;
    }
    return effectiveValue;
  }

  /// Returns the z-coordinate from which this button can be placed relative to its parent.
  double? getElevation(BuildContext context) {
    final effectiveValue = elevation;
    return effectiveValue;
  }

  /// Returns the shape of the button's [Material].
  ///
  /// The button's highlight and splash are clipped to this shape.
  /// If the button has an elevation, then its drop shadow is defined by this shape as well.
  ///
  /// If no value is set in the theme, then the [shape] from the
  /// current [AppBarTheme] is returned (the app theme is taken from the `context`).
  ShapeBorder? getShape(BuildContext context) {
    final effectiveShape = shape ?? AppBarTheme.of(context).shape;
    return effectiveShape;
  }

  /// Returns the default text style for the button.
  ///
  /// If no value is set in the theme, then the [bodyLarge] from [textTheme] is returned
  /// (the app theme is taken from the `context`).
  TextStyle? getTextStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    final effectiveTextStyle = (theme.textTheme.bodyLarge ?? const TextStyle())
        .copyWith(color: color)
        .merge(textStyle);
    return effectiveTextStyle;
  }

  /// Returns the icon to display in the button.
  IconData getCheckIcon(BuildContext context) {
    final effectiveValue = checkIcon ??
        ((location == FilesystemPickerActionLocation.barCenter)
            ? Icons.check_circle
            : Icons.check);
    return effectiveValue;
  }

  /// Returns [IconThemeData], for the icon in the button.
  IconThemeData getCheckIconTheme(BuildContext context) {
    return IconThemeData(
      color: checkIconColor ?? getForegroundColor(context),
      size: checkIconSize ?? defaultCheckIconSize,
    );
  }

  /// Returns the location of the floating button, depending on the [location] parameter.
  /// If `barCenter` is set in [location], it returns `null`.
  FloatingActionButtonLocation? getFloatingButtonLocation(
      BuildContext context) {
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

  /// Returns true if [location] is set to `barCenter`.
  bool get isBarMode => location == FilesystemPickerActionLocation.barCenter;

  /// Returns true if [location] is set to `floatingStart`, `floatingCenter` or `floatingEnd`.
  bool get isFABMode => location != FilesystemPickerActionLocation.barCenter;

  /// Returns a new picker action theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerActionThemeData merge(FilesystemPickerActionThemeData base) {
    return FilesystemPickerActionThemeData(
      location: _location ?? base.location,
      foregroundColor: foregroundColor ?? base.foregroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? base.disabledForegroundColor,
      backgroundColor: backgroundColor ?? base.backgroundColor,
      elevation: elevation ?? base.elevation,
      shape: shape ?? base.shape,
      textStyle: base.textStyle?.merge(textStyle) ?? textStyle,
      checkIcon: checkIcon ?? base.checkIcon,
      checkIconColor: checkIconColor ?? base.checkIconColor,
      checkIconSize: checkIconSize ?? base.checkIconSize,
    );
  }
}
