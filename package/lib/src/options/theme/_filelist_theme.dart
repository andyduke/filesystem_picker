import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension _IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// An object that allows you to set an icon for a list of file
/// extensions. Used in [FilesystemPickerFileListFileTypesTheme].
@immutable
class FilesystemPickerFileListFileTypesThemeItem {
  /// A list of file extensions for which the icon is set.
  final List<String> extensions;

  /// Icon, for the list of extensions specified in [extensions].
  final IconData? icon;

  /// Creates a new FilesystemPickerFileListFileTypesThemeItem object.
  const FilesystemPickerFileListFileTypesThemeItem({
    required this.extensions,
    required this.icon,
  });
}

/// The interface of the object defining the set of icons for file types by extensions.
/// Used in [FilesystemPickerFileListThemeData].
abstract class FilesystemPickerFileListFileTypesThemeBase {
  /// Creates a new FilesystemPickerFileListFileTypesThemeBase object.
  const FilesystemPickerFileListFileTypesThemeBase();

  /// Returns a description object [FilesystemPickerFileListFileTypesThemeItem] for the passed `extension`
  /// if a description is found for it in the current set.
  FilesystemPickerFileListFileTypesThemeItem? match(String extension,
      {bool caseSensitive = false});

  /// Returns a new set that combines descriptions for extensions with those passed as a parameter.
  FilesystemPickerFileListFileTypesThemeBase merge(
      FilesystemPickerFileListFileTypesThemeBase? base);
}

/// An object that defines a set of icons for file types by extensions in the picker file list.
/// Used in [FilesystemPickerFileListThemeData].
@immutable
class FilesystemPickerFileListFileTypesTheme
    extends FilesystemPickerFileListFileTypesThemeBase {
  /// Default icons for image files (jpeg, jpg, png) and databases (db, sqlite, sqlite3).
  static const FilesystemPickerFileListFileTypesTheme defaultFileTypes =
      FilesystemPickerFileListFileTypesTheme([
    // Databases
    FilesystemPickerFileListFileTypesThemeItem(
      extensions: ['db', 'sqlite', 'sqlite3'],
      icon: Icons.dns,
    ),

    // Images
    FilesystemPickerFileListFileTypesThemeItem(
      extensions: ['jpg', 'jpeg', 'png'],
      icon: Icons.image,
    ),
  ]);

  /// A list of icon definitions for file types.
  final List<FilesystemPickerFileListFileTypesThemeItem> types;

  /// Creates a set of icon definitions for file types.
  const FilesystemPickerFileListFileTypesTheme(this.types);

  /// Returns a description object [FilesystemPickerFileListFileTypesThemeItem] for the passed `extension`
  /// if a description is found for it in the current set.
  @override
  FilesystemPickerFileListFileTypesThemeItem? match(String extension,
      {bool caseSensitive = false}) {
    final String ext = !caseSensitive ? extension.toLowerCase() : extension;
    return types.firstWhereOrNull((type) {
      if (!caseSensitive) {
        return type.extensions.map((e) => e.toLowerCase()).contains(ext);
      } else {
        return type.extensions.contains(ext);
      }
    });
  }

  /// Returns a new set that combines descriptions for extensions with those passed as a parameter.
  @override
  FilesystemPickerFileListFileTypesThemeBase merge(
      FilesystemPickerFileListFileTypesThemeBase? base) {
    if (base is FilesystemPickerFileListFileTypesTheme) {
      return FilesystemPickerFileListFileTypesTheme([...types, ...base.types]);
    } else {
      return this;
    }
  }
}

/// Defines the theme for the list of folders and files displayed in the picker.
///
/// Here you can customize the list view by setting icons, icon color, text styles, etc.
@immutable
class FilesystemPickerFileListThemeData with Diagnosticable {
  /// The default icon size.
  static const double defaultIconSize = 32;

  /// The default icon size for going up to the parent folder.
  static const double defaultUpIconSize = 32;

  /// The default icon for going up to the parent folder.
  static const IconData defaultUpIcon = Icons.arrow_upward;

  /// The text of the list item to go up to the parent folder.
  static const String defaultUpText = '..';

  /// The default icon size for selecting a file (displayed on the right side of the list row from the file name).
  static const double defaultCheckIconSize = 24;

  /// The default scaling factor, for the size of the text of the folder or file name.
  static const double defaultTextScaleFactor = 1.2;

  /// The size of the folder or file icon in the list row displayed in the picker.
  final double? iconSize;

  /// The icon of the list row, for going up to the parent folder.
  final IconData? upIcon;

  /// The size of the list row icon, for going up to the parent folder.
  final double? upIconSize;

  /// The color of the icon of the list row, for going up to the parent folder.
  final Color? upIconColor;

  /// The text of the list row to go up to the parent folder.
  final String? upText;

  /// The text style of the list row, for going up to the parent folder.
  final TextStyle? upTextStyle;

  /// The shortcut icon in the picker list row.
  final IconData? shortcutIcon;

  /// The color of the shortcut icon in the picker list row.
  final Color? shortcutIconColor;

  /// The text style of the shortcut name in the picker list row.
  final TextStyle? shortcutTextStyle;

  /// The folder icon in the picker list row.
  final IconData? folderIcon;

  /// The color of the folder icon in the picker list row.
  final Color? folderIconColor;

  /// The text style of the folder name in the picker list row.
  final TextStyle? folderTextStyle;

  /// The file icon in the picker list row. Except for the file types specified in [fileTypes].
  final IconData? fileIcon;

  /// The color of the file icon in the picker list row.
  final Color? fileIconColor;

  /// The text style of the file name in the picker list row.
  final TextStyle? fileTextStyle;

  /// The icon for selecting a file (displayed on the right side of the list row from the file name).
  final IconData? checkIcon;

  /// The color of the icon for selecting a file.
  final Color? checkIconColor;

  /// The size of the icon for selecting a file.
  final double? checkIconSize;

  /// The scaling factor of the text of the folder name or file name.
  /// For example, for a value of 1.5, the text will be 50% larger than the specified font size.
  final double? textScaleFactor;

  /// The color of the progress indicator for loading the list of folders and files
  /// for the current path to display in the picker.
  final Color? progressIndicatorColor;

  /// A set of icons for file types by extensions in the picker file list.
  FilesystemPickerFileListFileTypesThemeBase get fileTypes =>
      _fileTypes ?? FilesystemPickerFileListFileTypesTheme.defaultFileTypes;
  final FilesystemPickerFileListFileTypesThemeBase? _fileTypes;

  /// Creates a theme for the list of folders and files displayed in the picker.
  FilesystemPickerFileListThemeData({
    this.iconSize,
    this.upIcon,
    this.upIconSize,
    this.upIconColor,
    this.upText,
    this.upTextStyle,
    this.shortcutIcon,
    this.shortcutIconColor,
    this.shortcutTextStyle,
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
    FilesystemPickerFileListFileTypesThemeBase? fileTypes,
  }) : _fileTypes = fileTypes;

  /// Returns the size of the folder or file icon in the list row displayed in the picker.
  double getIconSize(BuildContext context) {
    final effectiveValue = iconSize ?? defaultIconSize;
    return effectiveValue;
  }

  /// Returns the icon of the list row, for going up to the parent folder.
  IconData getUpIcon(BuildContext context) {
    final effectiveValue = upIcon ?? defaultUpIcon;
    return effectiveValue;
  }

  /// Returns [IconThemeData], for the icon of the list row, for going up to the parent folder.
  IconThemeData getUpIconTheme(BuildContext context) {
    return IconThemeData(
      color: upIconColor ?? ListTileTheme.of(context).iconColor,
      size: upIconSize ?? defaultUpIconSize,
    );
  }

  /// Returns the text of the list row to go up to the parent folder.
  String getUpText(BuildContext context) {
    final effectiveValue = upText ?? defaultUpText;
    return effectiveValue;
  }

  /// Returns the text style of the list row, for going up to the parent folder.
  TextStyle getUpTextStyle(BuildContext context) {
    final effectiveValue = upTextStyle ?? const TextStyle();
    return effectiveValue;
  }

  /// Returns the scaling factor of the text of the list row to go up to the parent folder.
  double getUpTextScaleFactor(BuildContext context) {
    return (upTextStyle == null) ? 1.5 : 1.0;
  }

  /// Returns the shortcut icon in the picker list row.
  IconData getShortcutIcon(BuildContext context) {
    final effectiveValue = shortcutIcon ?? Icons.folder_special;
    return effectiveValue;
  }

  /// Returns the color of the shortcut icon in the picker list row.
  Color getShortcutIconColor(BuildContext context, [Color? color]) {
    final effectiveValue =
        color ?? shortcutIconColor ?? Theme.of(context).unselectedWidgetColor;
    return effectiveValue;
  }

  /// Returns the text style of the shortcut name in the picker list row.
  TextStyle getShortcutTextStyle(BuildContext context) {
    final effectiveValue = shortcutTextStyle ?? const TextStyle();
    return effectiveValue;
  }

  /// Returns the folder icon in the picker list row.
  IconData getFolderIcon(BuildContext context) {
    final effectiveValue = folderIcon ?? Icons.folder;
    return effectiveValue;
  }

  /// Returns the color of the folder icon in the picker list row.
  Color getFolderIconColor(BuildContext context, [Color? color]) {
    final effectiveValue =
        color ?? folderIconColor ?? Theme.of(context).unselectedWidgetColor;
    return effectiveValue;
  }

  /// Returns the text style of the folder name in the picker list row.
  TextStyle getFolderTextStyle(BuildContext context) {
    final effectiveValue = folderTextStyle ?? const TextStyle();
    return effectiveValue;
  }

  /// Returns the file icon in the picker list row.
  IconData getFileIcon(BuildContext context,
      [String? extension, bool caseSensitive = false]) {
    final FilesystemPickerFileListFileTypesThemeItem? fileType =
        (extension != null)
            ? fileTypes.match(extension, caseSensitive: caseSensitive)
            : null;
    final effectiveValue = fileType?.icon ?? fileIcon ?? Icons.description;
    return effectiveValue;
  }

  /// Returns the color of the file icon in the picker list row.
  Color getFileIconColor(BuildContext context, [Color? color]) {
    final effectiveValue =
        color ?? fileIconColor ?? Theme.of(context).unselectedWidgetColor;
    return effectiveValue;
  }

  /// Returns the text style of the file name in the picker list row.
  TextStyle getFileTextStyle(BuildContext context) {
    final effectiveValue = fileTextStyle ?? const TextStyle();
    return effectiveValue;
  }

  /// Returns the icon for selecting a file (displayed on the right side of the list row from the file name).
  IconData getCheckIcon(BuildContext context) {
    final effectiveValue = checkIcon ?? Icons.check_circle;
    return effectiveValue;
  }

  /// Returns [IconThemeData], for the icon for selecting a file (displayed on the right side of the list row from the file name).
  IconThemeData getCheckIconTheme(BuildContext context) {
    return IconThemeData(
      color: checkIconColor ?? Theme.of(context).disabledColor,
      size: checkIconSize ?? defaultCheckIconSize,
    );
  }

  /// Returns the scaling factor of the text of the folder name or file name.
  double getTextScaleFactor(BuildContext context, bool isFile) {
    if (textScaleFactor != null) return textScaleFactor!;

    if (!isFile) {
      return (folderTextStyle == null) ? defaultTextScaleFactor : 1.0;
    } else {
      return (fileTextStyle == null) ? defaultTextScaleFactor : 1.0;
    }
  }

  /// Returns the color of the progress indicator for loading the list
  /// of folders and files for the current path to display in the picker.
  Color? getProgressIndicatorColor(BuildContext context, [Color? color]) {
    final effectiveValue = color ?? progressIndicatorColor;
    return effectiveValue;
  }

  /// Returns a new theme for the list of folders and files that matches this theme
  /// but with some values replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  FilesystemPickerFileListThemeData merge(
      FilesystemPickerFileListThemeData base) {
    return FilesystemPickerFileListThemeData(
      iconSize: iconSize ?? base.iconSize,
      upIcon: upIcon ?? base.upIcon,
      upIconSize: upIconSize ?? base.upIconSize,
      upIconColor: upIconColor ?? base.upIconColor,
      upText: upText ?? base.upText,
      upTextStyle: base.upTextStyle?.merge(upTextStyle) ?? upTextStyle,
      folderIcon: folderIcon ?? base.folderIcon,
      folderIconColor: folderIconColor ?? base.folderIconColor,
      folderTextStyle:
          base.folderTextStyle?.merge(folderTextStyle) ?? folderTextStyle,
      fileIcon: fileIcon ?? base.fileIcon,
      fileIconColor: fileIconColor ?? base.fileIconColor,
      fileTextStyle: base.fileTextStyle?.merge(fileTextStyle) ?? fileTextStyle,
      checkIcon: checkIcon ?? base.checkIcon,
      checkIconColor: checkIconColor ?? base.checkIconColor,
      checkIconSize: checkIconSize ?? base.checkIconSize,
      textScaleFactor: textScaleFactor ?? base.textScaleFactor,
      progressIndicatorColor:
          progressIndicatorColor ?? base.progressIndicatorColor,
      fileTypes: _fileTypes?.merge(base._fileTypes) ?? base._fileTypes,
    );
  }
}
