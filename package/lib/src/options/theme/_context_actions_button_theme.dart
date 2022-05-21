import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FilesystemPickerContextActionsButtonThemeData with Diagnosticable {
  final IconThemeData? iconTheme;

  const FilesystemPickerContextActionsButtonThemeData({
    this.iconTheme,
  });

  IconThemeData getIconTheme(BuildContext context) {
    final effectiveValue = IconThemeData(
      color: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).primaryTextTheme.headline6?.color,
    ).merge(iconTheme);
    return effectiveValue;
  }

  /// Returns a new context action button theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsButtonThemeData merge(FilesystemPickerContextActionsButtonThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsButtonThemeData(
      iconTheme: iconTheme?.merge(base.iconTheme) ?? base.iconTheme,
    );
  }
}
