import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'options/theme/_filelist_theme.dart';

/// A single row displaying a folder or file, the corresponding icon and the trailing
/// selection button for the file (configured in the `fileTileSelectMode` parameter).
///
/// Used in conjunction with the `FilesystemList` widget.
class FilesystemListTile extends StatelessWidget {
  /// The type of view (folder and files, folder only or files only), by default `FilesystemType.all`.
  final FilesystemType fsType;

  /// The entity of the file system that should be displayed by the widget.
  final FileSystemEntity item;

  /// The color of the folder icon in the list.
  final Color? folderIconColor;

  /// Called when the user has touched a subfolder list item.
  final ValueChanged<Directory> onChange;

  /// Called when a file system item is selected.
  final ValueSelected onSelect;

  /// Specifies how to files can be selected (either tapping on the whole tile or only on trailing button).
  final FileTileSelectMode fileTileSelectMode;

  /// Specifies a list theme in which colors, fonts, icons, etc. can be customized.
  final FilesystemPickerFileListThemeData? theme;

  /// Specifies the extension comparison mode to determine the icon specified for the file types in the theme,
  /// case-sensitive or case-insensitive, by default it is insensitive.
  final bool caseSensitiveFileExtensionComparison;

  /// Creates a file system entity list tile.
  FilesystemListTile({
    Key? key,
    this.fsType = FilesystemType.all,
    required this.item,
    this.folderIconColor,
    required this.onChange,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.theme,
    this.caseSensitiveFileExtensionComparison = false,
  }) : super(key: key);

  Widget _leading(BuildContext context, FilesystemPickerFileListThemeData theme,
      bool isFile) {
    if (item is Directory) {
      return Icon(
        theme.getFolderIcon(context),
        color: theme.getFolderIconColor(context, folderIconColor),
        size: theme.getIconSize(context),
      );
    } else {
      return _fileIcon(context, theme, item.path, isFile);
    }
  }

  /// Set the icon for a file
  Icon _fileIcon(BuildContext context, FilesystemPickerFileListThemeData theme,
      String filename, bool isFile,
      [Color? color]) {
    final _extension = filename.split(".").last;
    IconData icon = theme.getFileIcon(
        context, _extension, caseSensitiveFileExtensionComparison);

    return Icon(
      icon,
      color: theme.getFileIconColor(context, color),
      size: theme.getIconSize(context),
    );
  }

  Widget? _trailing(BuildContext context,
      FilesystemPickerFileListThemeData theme, bool isFile) {
    final isCheckable = ((fsType == FilesystemType.all) ||
        ((fsType == FilesystemType.file) &&
            (item is File) &&
            (fileTileSelectMode != FileTileSelectMode.wholeTile)));

    if (isCheckable) {
      final iconTheme = theme.getCheckIconTheme(context);
      return InkResponse(
        child: Icon(
          theme.getCheckIcon(context),
          color: iconTheme.color,
          size: iconTheme.size,
        ),
        onTap: () => onSelect(item.absolute.path),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? FilesystemPickerFileListThemeData();
    final isFile = (fsType == FilesystemType.file) && (item is File);
    final style = !isFile
        ? effectiveTheme.getFolderTextStyle(context)
        : effectiveTheme.getFileTextStyle(context);

    return ListTile(
      key: Key(item.absolute.path),
      leading: _leading(context, effectiveTheme, isFile),
      trailing: _trailing(context, effectiveTheme, isFile),
      title: Text(Path.basename(item.path),
          style: style,
          textScaleFactor: effectiveTheme.getTextScaleFactor(context, isFile)),
      onTap: (item is Directory)
          ? () => onChange(item as Directory)
          : ((fsType == FilesystemType.file &&
                  fileTileSelectMode == FileTileSelectMode.wholeTile)
              ? () => onSelect(item.absolute.path)
              : null),
    );
  }
}
