import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_context_actions_theme.dart';
import '_filelist_theme.dart';
import '_picker_action_theme.dart';
import '_topbar_theme.dart';
import 'theme_base.dart';

export '_topbar_theme.dart';
export '_breadcrumbs_theme.dart';
export '_filelist_theme.dart';
export '_picker_action_theme.dart';
export '_context_actions_menu_theme.dart';
export '_context_actions_button_theme.dart';
export '_context_actions_theme.dart';
export 'theme_base.dart';
export 'theme_auto_system.dart';

/// Defines a theme for the [FilesystemPicker], allowing you to set colors, fonts, and icons for it.
///
/// You can set a common theme for all picker instances using [FilesystemPickerDefaultOptions] or pass
/// the `theme` directly when opening the picker using the `open`, `openDialog`,
/// `openBottomSheet` methods.
///
/// When passing a theme to the `open`, `openDialog`, `openBottomSheet` methods, you can set
/// only some of the parameters, the rest will be used from the theme in
/// [FilesystemPickerDefaultOptions] or the default theme (this behavior can be changed
/// using the `inherit` parameter).
///
/// You can use [FilesystemPickerAutoSystemTheme] to set a theme that will adapt to the light
/// and dark presentation of the application (and the operating system).
@immutable
class FilesystemPickerTheme
    with Diagnosticable
    implements FilesystemPickerThemeBase {
  static const bool _kDefaultInherit = true;

  /// Create a theme that can be used to customize the [FilesystemPicker] presentation
  ///
  /// * [inherit] whether to use unspecified values from `FilesystemPickerDefaultOptions`; default value is true.
  /// * [backgroundColor] specifies the background color of the picker; if this property is null, then the `scaffoldBackgroundColor` from the current
  /// application theme is used.
  /// * [topBar] specifies the theme for the `AppBar` widget used in the picker.
  /// * [messageTextStyle] specifies the text style for messages in the center of the picker (for example,
  /// message about lack of access permissions).
  /// * [fileList] specifies the theme for the FilesystemList widget used in the picker.
  /// * [pickerAction] specifies the theme for the picker action.
  /// * [contextActions] specifies the theme for the context actions.
  const FilesystemPickerTheme({
    this.inherit = _kDefaultInherit,
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? fileList,
    FilesystemPickerActionThemeData? pickerAction,
    FilesystemPickerContextActionsThemeData? contextActions,
  })  : _backgroundColor = backgroundColor,
        _topBar = topBar,
        _messageTextStyle = messageTextStyle,
        _fileList = fileList,
        _pickerAction = pickerAction,
        _contextActions = contextActions;

  /// Whether to use unspecified values from `FilesystemPickerDefaultOptions`.
  final bool inherit;

  /// Specifies the background color of the picker.
  ///
  /// If this property is null, then the `scaffoldBackgroundColor` from the current
  /// application theme is used.
  final Color? _backgroundColor;

  /// Specifies the theme for the `AppBar` widget used in the picker.
  final FilesystemPickerTopBarThemeData? _topBar;

  /// Specifies the text style for messages in the center of the picker (for example,
  /// message about lack of access permissions).
  final TextStyle? _messageTextStyle;

  /// Specifies the theme for the FilesystemList widget used in the picker.
  final FilesystemPickerFileListThemeData? _fileList;

  /// Specifies the theme for the picker action.
  final FilesystemPickerActionThemeData? _pickerAction;

  /// Specifies the theme for the context actions.
  final FilesystemPickerContextActionsThemeData? _contextActions;

  /// Returns the background color of the picker using the `context` to get the default
  /// background color.
  ///
  /// If no value is set in the theme, then the `scaffoldBackgroundColor` from the
  /// current app theme is returned (the app theme is taken from the `context`).
  @override
  Color getBackgroundColor(BuildContext context, [Color? color]) {
    final effectiveValue =
        color ?? _backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return effectiveValue;
  }

  /// Returns the theme for the Picker's `AppBar` using the `context` to get the defaults.
  @override
  FilesystemPickerTopBarThemeData getTopBar(BuildContext context) {
    return _topBar ?? FilesystemPickerTopBarThemeData();
  }

  /// Returns the text style for messages in the center of the picker,
  /// using the `context` to get the default values.
  @override
  TextStyle getMessageTextStyle(BuildContext context) {
    return _messageTextStyle ?? const TextStyle();
  }

  /// Returns the theme for the FilesystemList widget used in the picker,
  /// using `context` to get the defaults.
  @override
  FilesystemPickerFileListThemeData getFileList(BuildContext context) {
    return _fileList ?? FilesystemPickerFileListThemeData();
  }

  /// Returns the theme for the picker action, using `context` to get the defaults.
  @override
  FilesystemPickerActionThemeData getPickerAction(BuildContext context) {
    return _pickerAction ?? FilesystemPickerActionThemeData();
  }

  /// Returns the theme for the context actions, using `context` to get the defaults.
  @override
  FilesystemPickerContextActionsThemeData getContextActions(
      BuildContext context) {
    return _contextActions ?? const FilesystemPickerContextActionsThemeData();
  }

  /// Returns a new picker theme that matches this picker theme but with some values
  /// replaced by the non-null parameters of the given picker theme.
  ///
  /// If the given picker theme is null, simply returns this picker theme.
  @override
  FilesystemPickerThemeBase merge(
      BuildContext context, FilesystemPickerThemeBase? base) {
    if (!inherit || base == null) return this;

    return FilesystemPickerTheme(
      inherit: false,
      backgroundColor: _backgroundColor ?? base.getBackgroundColor(context),
      topBar:
          _topBar?.merge(base.getTopBar(context)) ?? base.getTopBar(context),
      messageTextStyle:
          base.getMessageTextStyle(context).merge(_messageTextStyle),
      fileList: _fileList?.merge(base.getFileList(context)) ??
          base.getFileList(context),
      pickerAction: _pickerAction?.merge(base.getPickerAction(context)) ??
          base.getPickerAction(context),
      contextActions: _contextActions?.merge(base.getContextActions(context)) ??
          base.getContextActions(context),
    );
  }

  /// The hash code for this object.
  @override
  int get hashCode {
    return Object.hash(
      _topBar,
      _messageTextStyle,
      _fileList,
      _pickerAction,
      _contextActions,
    );
  }

  /// The equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerTheme &&
        other._topBar == _topBar &&
        other._messageTextStyle == _messageTextStyle &&
        other._fileList == _fileList &&
        other._pickerAction == _pickerAction &&
        other._contextActions == _contextActions;
  }

  /// Add additional properties associated with the node.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerTopBarThemeData>(
        'topBar', _topBar,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'permissionMessageTextStyle', _messageTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerFileListThemeData>(
        'list', _fileList,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerActionThemeData>(
        'pickerAction', _pickerAction,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerContextActionsThemeData>(
        'contextActions', _contextActions,
        defaultValue: null));
  }
}
