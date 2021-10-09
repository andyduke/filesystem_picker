import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_filelist_theme.dart';
import '_picker_action_theme.dart';
import '_topbar_theme.dart';
import 'theme_base.dart';

export '_topbar_theme.dart';
export '_breadcrumbs_theme.dart';
export '_filelist_theme.dart';
export '_picker_action_theme.dart';
export 'theme_auto_system.dart';

@immutable
class FilesystemPickerTheme with Diagnosticable implements FilesystemPickerThemeBase {
  static const bool _kDefaultInherit = true;

  const FilesystemPickerTheme({
    this.inherit = _kDefaultInherit,
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? fileList,
    FilesystemPickerActionThemeData? pickerAction,
  })  : _backgroundColor = backgroundColor,
        _topBar = topBar,
        _messageTextStyle = messageTextStyle,
        _fileList = fileList,
        _pickerAction = pickerAction;

  factory FilesystemPickerTheme.light({
    bool inherit = _kDefaultInherit,
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? fileList,
    FilesystemPickerActionThemeData? pickerAction,
  }) {
    return FilesystemPickerTheme(
      inherit: inherit,
      backgroundColor: backgroundColor,
      topBar: topBar,
      messageTextStyle: messageTextStyle,
      fileList: fileList,
      pickerAction: pickerAction,
    );
  }

  factory FilesystemPickerTheme.dark({
    bool inherit = _kDefaultInherit,
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? fileList,
    FilesystemPickerActionThemeData? pickerAction,
  }) {
    return FilesystemPickerTheme(
      inherit: inherit,
      backgroundColor: backgroundColor,
      topBar: topBar,
      messageTextStyle: messageTextStyle,
      fileList: fileList,
      pickerAction: pickerAction,
    );
  }

  final bool inherit;
  final Color? _backgroundColor;
  final FilesystemPickerTopBarThemeData? _topBar;
  final TextStyle? _messageTextStyle;
  final FilesystemPickerFileListThemeData? _fileList;
  final FilesystemPickerActionThemeData? _pickerAction;

  Color getBackgroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? _backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return effectiveValue;
  }

  FilesystemPickerTopBarThemeData getTopBar(BuildContext context) {
    return _topBar ?? FilesystemPickerTopBarThemeData();
  }

  TextStyle getMessageTextStyle(BuildContext context) {
    return _messageTextStyle ?? TextStyle();
  }

  FilesystemPickerFileListThemeData getFileList(BuildContext context) {
    return _fileList ?? FilesystemPickerFileListThemeData();
  }

  FilesystemPickerActionThemeData getPickerAction(BuildContext context) {
    return _pickerAction ?? FilesystemPickerActionThemeData();
  }

  FilesystemPickerThemeBase merge(BuildContext context, FilesystemPickerThemeBase? base) {
    if (!inherit || base == null) return this;

    return FilesystemPickerTheme(
      inherit: false,
      backgroundColor: _backgroundColor ?? base.getBackgroundColor(context),
      topBar: _topBar?.merge(base.getTopBar(context)) ?? base.getTopBar(context),
      messageTextStyle: base.getMessageTextStyle(context).merge(_messageTextStyle),
      fileList: _fileList?.merge(base.getFileList(context)) ?? base.getFileList(context),
      pickerAction: _pickerAction?.merge(base.getPickerAction(context)) ?? base.getPickerAction(context),
    );
  }

  @override
  int get hashCode {
    return hashValues(
      _topBar,
      _messageTextStyle,
      _fileList,
      _pickerAction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerTheme &&
        other._topBar == _topBar &&
        other._messageTextStyle == _messageTextStyle &&
        other._fileList == _fileList &&
        other._pickerAction == _pickerAction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerTopBarThemeData>('topBar', _topBar, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('permissionMessageTextStyle', _messageTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerFileListThemeData>('list', _fileList, defaultValue: null));
    properties
        .add(DiagnosticsProperty<FilesystemPickerActionThemeData>('pickerAction', _pickerAction, defaultValue: null));
  }
}
