import 'package:filesystem_picker/src/options/theme/_context_actions_button_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_context_actions_menu_theme.dart';

/// Defines the theme for the button and the menu of contextual actions
/// called from the upper-right corner of the picker.
@immutable
class FilesystemPickerContextActionsThemeData with Diagnosticable {
  /// Sets the theme for the popup menu with a list of actions if more than one action is specified.
  final FilesystemPickerContextActionsMenuThemeData? menuTheme;

  /// Sets the theme for the action button or the button that opens the popup menu
  /// if more than one action is specified.
  final FilesystemPickerContextActionsButtonThemeData? buttonTheme;

  /// Creates a theme that can be used to customize the contextual actions button and popup menu.
  const FilesystemPickerContextActionsThemeData({
    this.menuTheme,
    this.buttonTheme,
  });

  /// Returns the theme for the popup menu with a list of actions if more than one action is specified.
  FilesystemPickerContextActionsMenuThemeData getMenuTheme(
      BuildContext context) {
    return menuTheme ?? const FilesystemPickerContextActionsMenuThemeData();
  }

  /// Returns the theme for the action button or the button that opens the popup menu
  /// if more than one action is specified.
  FilesystemPickerContextActionsButtonThemeData getButtonTheme(
      BuildContext context) {
    return buttonTheme ?? const FilesystemPickerContextActionsButtonThemeData();
  }

  /// Returns a new context actions theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerContextActionsThemeData merge(
      FilesystemPickerContextActionsThemeData? base) {
    if (base == null) return this;

    return FilesystemPickerContextActionsThemeData(
      menuTheme: menuTheme?.merge(base.menuTheme) ?? base.menuTheme,
      buttonTheme: buttonTheme?.merge(base.buttonTheme) ?? base.buttonTheme,
    );
  }
}
