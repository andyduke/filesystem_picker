import 'dart:io';
import 'package:flutter/material.dart';
import 'common.dart';
import 'package:path/path.dart' as Path;

import 'options/theme/_filelist_theme.dart';

class FilesystemListTile extends StatelessWidget {
  // static double iconSize = 32;

  final FilesystemType fsType;
  final FileSystemEntity item;
  final Color? folderIconColor;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final FileTileSelectMode fileTileSelectMode;
  final FilesystemPickerFileListThemeData? theme;

  FilesystemListTile({
    Key? key,
    this.fsType = FilesystemType.all,
    required this.item,
    this.folderIconColor,
    required this.onChange,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.theme,
  }) : super(key: key);

  Widget _leading(BuildContext context, FilesystemPickerFileListThemeData theme, bool isFile) {
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
  Icon _fileIcon(BuildContext context, FilesystemPickerFileListThemeData theme, String filename, bool isFile,
      [Color? color]) {
    IconData icon = theme.getFileIcon(context);

    final _extension = filename.split(".").last;
    if (_extension == "db" || _extension == "sqlite" || _extension == "sqlite3") {
      icon = Icons.dns;
    } else if (_extension == "jpg" || _extension == "jpeg" || _extension == "png") {
      icon = Icons.image;
    }
    // default
    return Icon(
      icon,
      color: theme.getFileIconColor(context, color),
      size: theme.getIconSize(context),
    );
  }

  Widget? _trailing(BuildContext context, FilesystemPickerFileListThemeData theme, bool isFile) {
    final isCheckable = ((fsType == FilesystemType.all) ||
        ((fsType == FilesystemType.file) && (item is File) && (fileTileSelectMode != FileTileSelectMode.wholeTile)));

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
    final style = !isFile ? effectiveTheme.getFolderTextStyle(context) : effectiveTheme.getFileTextStyle(context);

    return ListTile(
      key: Key(item.absolute.path),
      leading: _leading(context, effectiveTheme, isFile),
      trailing: _trailing(context, effectiveTheme, isFile),
      title: Text(Path.basename(item.path),
          style: style, textScaleFactor: effectiveTheme.getTextScaleFactor(context, isFile)),
      onTap: (item is Directory)
          ? () => onChange(item as Directory)
          : ((fsType == FilesystemType.file && fileTileSelectMode == FileTileSelectMode.wholeTile)
              ? () => onSelect(item.absolute.path)
              : null),
    );
  }
}
