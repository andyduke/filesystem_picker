import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '_filelist_theme.dart';
import '_picker_action_theme.dart';
import '_topbar_theme.dart';

export '_topbar_theme.dart';
export '_breadcrumbs_theme.dart';
export '_filelist_theme.dart';
export '_picker_action_theme.dart';

@immutable
class FilesystemPickerTheme with Diagnosticable {
  const FilesystemPickerTheme({
    required this.brightness,
    this.backgroundColor,
    this.topBar,
    this.messageTextStyle,
    this.list,
    this.pickerAction,
  });

  factory FilesystemPickerTheme.light({
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? list,
    FilesystemPickerActionThemeData? pickerAction,
  }) {
    return FilesystemPickerTheme(
      backgroundColor: backgroundColor,
      brightness: Brightness.light,
      topBar: topBar,
      messageTextStyle: messageTextStyle,
      list: list,
      pickerAction: pickerAction,
    );
  }

  factory FilesystemPickerTheme.dark({
    Color? backgroundColor,
    FilesystemPickerTopBarThemeData? topBar,
    TextStyle? messageTextStyle,
    FilesystemPickerFileListThemeData? list,
    FilesystemPickerActionThemeData? pickerAction,
  }) {
    return FilesystemPickerTheme(
      backgroundColor: backgroundColor,
      brightness: Brightness.dark,
      topBar: topBar,
      messageTextStyle: messageTextStyle,
      list: list,
      pickerAction: pickerAction,
    );
  }

  final Brightness brightness;
  final Color? backgroundColor;
  final FilesystemPickerTopBarThemeData? topBar;
  final TextStyle? messageTextStyle;
  final FilesystemPickerFileListThemeData? list;
  final FilesystemPickerActionThemeData? pickerAction;

  Color getBackgroundColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return effectiveValue;
  }

  FilesystemPickerTopBarThemeData getTopBar(BuildContext context) {
    return topBar ?? FilesystemPickerTopBarThemeData();
  }

  TextStyle getMessageTextStyle(BuildContext context) {
    return messageTextStyle ?? TextStyle();
  }

  FilesystemPickerFileListThemeData getFileList(BuildContext context) {
    return list ?? FilesystemPickerFileListThemeData();
  }

  FilesystemPickerActionThemeData getPickerAction(BuildContext context) {
    return pickerAction ?? FilesystemPickerActionThemeData();
  }

  // TODO: AppBarTheme copyWith({}) {}

  @override
  int get hashCode {
    return hashValues(
      topBar,
      brightness,
      messageTextStyle,
      list,
      pickerAction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerTheme &&
        other.topBar == topBar &&
        other.brightness == brightness &&
        other.messageTextStyle == messageTextStyle &&
        other.list == list &&
        other.pickerAction == pickerAction;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerTopBarThemeData>('topBar', topBar, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('permissionMessageTextStyle', messageTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerFileListThemeData>('list', list, defaultValue: null));
    properties
        .add(DiagnosticsProperty<FilesystemPickerActionThemeData>('pickerAction', pickerAction, defaultValue: null));
  }
}
