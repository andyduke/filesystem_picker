import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the theme for the action button or the button that opens the popup menu
/// if more than one action is specified.
@immutable
class FilesystemPickerContextActionsButtonThemeData with Diagnosticable {
  /// The theme for the button icon.
  final IconThemeData? iconTheme;

  /// Creates a theme for the action button or the button that opens the popup menu
  /// if more than one action is specified.
  const FilesystemPickerContextActionsButtonThemeData({
    this.iconTheme,
  });

  /// Returns the theme for the button icon.
  IconThemeData getIconTheme(BuildContext context) {
    final effectiveValue = IconThemeData(
      color: Theme.of(context).appBarTheme.foregroundColor ??
          Theme.of(context).primaryTextTheme.titleLarge?.color,
    ).merge(iconTheme);
    return effectiveValue;
  }

  /// Returns a new context action button theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsButtonThemeData merge(
      FilesystemPickerContextActionsButtonThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsButtonThemeData(
      iconTheme: iconTheme?.merge(base.iconTheme) ?? base.iconTheme,
    );
  }
}
