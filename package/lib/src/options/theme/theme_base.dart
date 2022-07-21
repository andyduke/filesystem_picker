import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '_context_actions_theme.dart';
import '_filelist_theme.dart';
import '_picker_action_theme.dart';
import '_topbar_theme.dart';

/// An abstract base class for defining the picker theme interface.
abstract class FilesystemPickerThemeBase with Diagnosticable {
  /// Returns the background color of the picker.
  Color getBackgroundColor(BuildContext context, [Color? color]);

  /// Returns the theme for the Picker's `AppBar`.
  FilesystemPickerTopBarThemeData getTopBar(BuildContext context);

  /// Returns the text style for messages in the center of the picker.
  TextStyle getMessageTextStyle(BuildContext context);

  /// Returns the theme for the FilesystemList widget used in the picker.
  FilesystemPickerFileListThemeData getFileList(BuildContext context);

  /// Returns the theme for the picker action.
  FilesystemPickerActionThemeData getPickerAction(BuildContext context);

  FilesystemPickerContextActionsThemeData getContextActions(
      BuildContext context);

  /// Returns a new picker theme that matches this picker theme but with some values
  /// replaced by the non-null parameters of the given picker theme.
  ///
  /// If the given picker theme is null, simply returns this picker theme.
  FilesystemPickerThemeBase merge(
      BuildContext context, FilesystemPickerThemeBase? base);
}
