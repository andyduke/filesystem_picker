import 'package:filesystem_picker/src/options/theme/_context_actions_button_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_context_actions_menu_theme.dart';

/// Defines the theme for the button and the menu of contextual actions
/// called from the upper-right corner of the picker.
@immutable
class FilesystemPickerContextActionsThemeData with Diagnosticable {
  final FilesystemPickerContextActionsMenuThemeData? menuTheme;
  final FilesystemPickerContextActionsButtonThemeData? buttonTheme;

  const FilesystemPickerContextActionsThemeData({
    this.menuTheme,
    this.buttonTheme,
  });

  FilesystemPickerContextActionsMenuThemeData getMenuTheme(BuildContext context) {
    return menuTheme ?? FilesystemPickerContextActionsMenuThemeData();
  }

  FilesystemPickerContextActionsButtonThemeData getButtonTheme(BuildContext context) {
    return buttonTheme ?? FilesystemPickerContextActionsButtonThemeData();
  }

  /// Returns a new context actions theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsThemeData merge(FilesystemPickerContextActionsThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsThemeData(
      menuTheme: menuTheme?.merge(base.menuTheme) ?? base.menuTheme,
      buttonTheme: buttonTheme?.merge(base.buttonTheme) ?? base.buttonTheme,
    );
  }
}
