import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme.dart';
import 'theme_base.dart';

@immutable
class FilesystemPickerAutoSystemTheme with Diagnosticable implements FilesystemPickerThemeBase {
  const FilesystemPickerAutoSystemTheme({
    this.lightTheme,
    this.darkTheme,
  });

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
}
