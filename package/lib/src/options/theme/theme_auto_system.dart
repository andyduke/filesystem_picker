import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

/// Defines a theme for the `FilesystemPicker`, which adapts to the light or dark
/// theme of the application.
@immutable
class FilesystemPickerAutoSystemTheme
    with Diagnosticable
    implements FilesystemPickerThemeBase {
  static const bool _kDefaultInherit = true;

  /// Create an adaptive theme that can be used to customize the `FilesystemPicker` presentation
  const FilesystemPickerAutoSystemTheme({
    this.inherit = _kDefaultInherit,
    this.lightTheme,
    this.darkTheme,
  });

  /// Whether to use unspecified values from `FilesystemPickerDefaultOptions`.
  final bool inherit;

  /// Specifies the light theme for the `FilesystemPicker`.
  final FilesystemPickerTheme? lightTheme;

  /// Specifies the dark theme for the `FilesystemPicker`.
  final FilesystemPickerTheme? darkTheme;

  @protected
  Brightness getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  @protected
  FilesystemPickerThemeBase getEffectiveTheme(BuildContext context) {
    final brightness = getBrightness(context);

    final FilesystemPickerThemeBase effectiveTheme =
        (brightness == Brightness.light)
            ? (lightTheme ?? const FilesystemPickerTheme())
            : (darkTheme ?? const FilesystemPickerTheme());

    return effectiveTheme;
  }

  /// See [FilesystemPickerTheme.getBackgroundColor].
  @override
  Color getBackgroundColor(BuildContext context, [Color? color]) {
    return getEffectiveTheme(context).getBackgroundColor(context, color);
  }

  /// See [FilesystemPickerTheme.getTopBar].
  @override
  FilesystemPickerTopBarThemeData getTopBar(BuildContext context) {
    return getEffectiveTheme(context).getTopBar(context);
  }

  /// See [FilesystemPickerTheme.getMessageTextStyle].
  @override
  TextStyle getMessageTextStyle(BuildContext context) {
    return getEffectiveTheme(context).getMessageTextStyle(context);
  }

  /// See [FilesystemPickerTheme.getFileList].
  @override
  FilesystemPickerFileListThemeData getFileList(BuildContext context) {
    return getEffectiveTheme(context).getFileList(context);
  }

  /// See [FilesystemPickerTheme.getPickerAction].
  @override
  FilesystemPickerActionThemeData getPickerAction(BuildContext context) {
    return getEffectiveTheme(context).getPickerAction(context);
  }

  @override
  FilesystemPickerContextActionsThemeData getContextActions(
      BuildContext context) {
    return getEffectiveTheme(context).getContextActions(context);
  }

  /// See [FilesystemPickerTheme.merge].
  @override
  FilesystemPickerThemeBase merge(
      BuildContext context, FilesystemPickerThemeBase? base) {
    if (inherit && base is FilesystemPickerAutoSystemTheme) {
      return FilesystemPickerAutoSystemTheme(
        lightTheme: (lightTheme?.merge(context, base.lightTheme)
                as FilesystemPickerTheme?) ??
            base.lightTheme,
        darkTheme: (darkTheme?.merge(context, base.darkTheme)
                as FilesystemPickerTheme?) ??
            base.darkTheme,
      );
    }

    return this;
  }
}
