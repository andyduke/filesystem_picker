import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme.dart';
import 'theme_base.dart';

@immutable
class FilesystemPickerAutoSystemTheme with Diagnosticable implements FilesystemPickerThemeBase {
  static const bool _kDefaultInherit = true;

  const FilesystemPickerAutoSystemTheme({
    this.inherit = _kDefaultInherit,
    this.lightTheme,
    this.darkTheme,
  });

  final bool inherit;
  final FilesystemPickerTheme? lightTheme;
  final FilesystemPickerTheme? darkTheme;

  @protected
  Brightness getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  @protected
  FilesystemPickerThemeBase getEffectiveTheme(BuildContext context) {
    final brightness = getBrightness(context);

    final FilesystemPickerThemeBase effectiveTheme = (brightness == Brightness.light)
        ? (lightTheme ?? FilesystemPickerTheme.light())
        : (darkTheme ?? FilesystemPickerTheme.dark());

    return effectiveTheme;
  }

  Color getBackgroundColor(BuildContext context, [Color? color]) {
    return getEffectiveTheme(context).getBackgroundColor(context, color);
  }

  FilesystemPickerTopBarThemeData getTopBar(BuildContext context) {
    return getEffectiveTheme(context).getTopBar(context);
  }

  TextStyle getMessageTextStyle(BuildContext context) {
    return getEffectiveTheme(context).getMessageTextStyle(context);
  }

  FilesystemPickerFileListThemeData getFileList(BuildContext context) {
    return getEffectiveTheme(context).getFileList(context);
  }

  FilesystemPickerActionThemeData getPickerAction(BuildContext context) {
    return getEffectiveTheme(context).getPickerAction(context);
  }

  FilesystemPickerThemeBase merge(BuildContext context, FilesystemPickerThemeBase? base) {
    if (inherit && base is FilesystemPickerAutoSystemTheme) {
      return FilesystemPickerAutoSystemTheme(
        lightTheme: (lightTheme?.merge(context, base.lightTheme) as FilesystemPickerTheme?) ?? base.lightTheme,
        darkTheme: (darkTheme?.merge(context, base.darkTheme) as FilesystemPickerTheme?) ?? base.darkTheme,
      );
    }

    return this;
  }
}
