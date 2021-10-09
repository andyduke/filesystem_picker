import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FilesystemPickerFileListThemeData with Diagnosticable {
  static const double defaultIconSize = 32;
  static const double defaultUpIconSize = 32;
  static const String defaultUpText = '..';
  static const double defaultCheckIconSize = 24;
  static const double defaultTextScaleFactor = 1.2;

  final double? iconSize;

  final IconData? upIcon;
  final double? upIconSize;
  final Color? upIconColor;
  final String? upText;
  final TextStyle? upTextStyle;

  final IconData? folderIcon;
  final Color? folderIconColor;
  final TextStyle? folderTextStyle;

  final IconData? fileIcon;
  final Color? fileIconColor;
  final TextStyle? fileTextStyle;

  final IconData? checkIcon;
  final Color? checkIconColor;
  final double? checkIconSize;

  final double? textScaleFactor;

  final Color? progressIndicatorColor;

  // TODO: Extensions Icons

  FilesystemPickerFileListThemeData({
    this.iconSize,
    this.upIcon,
    this.upIconSize,
    this.upIconColor,
    this.upText,
    this.upTextStyle,
    this.folderIcon,
    this.folderIconColor,
    this.folderTextStyle,
    this.fileIcon,
    this.fileIconColor,
    this.fileTextStyle,
    this.checkIcon,
    this.checkIconColor,
    this.checkIconSize,
    this.textScaleFactor,
    this.progressIndicatorColor,
  });

  double getIconSize(BuildContext context) {
    final effectiveValue = iconSize ?? defaultIconSize;
    return effectiveValue;
  }

  IconData getUpIcon(BuildContext context) {
    final effectiveValue = upIcon ?? Icons.arrow_upward;
    return effectiveValue;
  }

  IconThemeData getUpIconTheme(BuildContext context) {
    return IconThemeData(
      color: upIconColor ?? ListTileTheme.of(context).iconColor,
      size: upIconSize ?? defaultUpIconSize,
    );
  }

  String getUpText(BuildContext context) {
    final effectiveValue = upText ?? defaultUpText;
    return effectiveValue;
  }

  TextStyle getUpTextStyle(BuildContext context) {
    final effectiveValue = upTextStyle ?? TextStyle();
    return effectiveValue;
  }

  double getUpTextScaleFactor(BuildContext context) {
    return (upTextStyle == null) ? 1.5 : 1.0;
  }

  IconData getFolderIcon(BuildContext context) {
    final effectiveValue = folderIcon ?? Icons.folder;
    return effectiveValue;
  }

  Color getFolderIconColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? folderIconColor ?? Theme.of(context).unselectedWidgetColor;
    return effectiveValue;
  }

  TextStyle getFolderTextStyle(BuildContext context) {
    final effectiveValue = folderTextStyle ?? TextStyle();
    return effectiveValue;
  }

  IconData getFileIcon(BuildContext context) {
    final effectiveValue = fileIcon ?? Icons.description;
    return effectiveValue;
  }

  Color getFileIconColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? fileIconColor ?? Theme.of(context).unselectedWidgetColor;
    return effectiveValue;
  }

  TextStyle getFileTextStyle(BuildContext context) {
    final effectiveValue = fileTextStyle ?? TextStyle();
    return effectiveValue;
  }

  IconData getCheckIcon(BuildContext context) {
    final effectiveValue = checkIcon ?? Icons.check_circle;
    return effectiveValue;
  }

  IconThemeData getCheckIconTheme(BuildContext context) {
    return IconThemeData(
      color: checkIconColor ?? Theme.of(context).disabledColor,
      size: checkIconSize ?? defaultCheckIconSize,
    );
  }

  double getTextScaleFactor(BuildContext context, bool isFile) {
    if (textScaleFactor != null) return textScaleFactor!;

    if (!isFile) {
      return (folderTextStyle == null) ? defaultTextScaleFactor : 1.0;
    } else {
      return (fileTextStyle == null) ? defaultTextScaleFactor : 1.0;
    }
  }

  Color? getProgressIndicatorColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? progressIndicatorColor;
    return effectiveValue;
  }

  FilesystemPickerFileListThemeData merge(FilesystemPickerFileListThemeData base) {
    return FilesystemPickerFileListThemeData(
      iconSize: iconSize ?? base.iconSize,
      upIcon: upIcon ?? base.upIcon,
      upIconSize: upIconSize ?? base.upIconSize,
      upIconColor: upIconColor ?? base.upIconColor,
      upText: upText ?? base.upText,
      upTextStyle: base.upTextStyle?.merge(upTextStyle) ?? upTextStyle,
      folderIcon: folderIcon ?? base.folderIcon,
      folderIconColor: folderIconColor ?? base.folderIconColor,
      folderTextStyle: base.folderTextStyle?.merge(folderTextStyle) ?? folderTextStyle,
      fileIcon: fileIcon ?? base.fileIcon,
      fileIconColor: fileIconColor ?? base.fileIconColor,
      fileTextStyle: base.fileTextStyle?.merge(fileTextStyle) ?? fileTextStyle,
      checkIcon: checkIcon ?? base.checkIcon,
      checkIconColor: checkIconColor ?? base.checkIconColor,
      checkIconSize: checkIconSize ?? base.checkIconSize,
      textScaleFactor: textScaleFactor ?? base.textScaleFactor,
      progressIndicatorColor: progressIndicatorColor ?? base.progressIndicatorColor,
    );
  }
}
