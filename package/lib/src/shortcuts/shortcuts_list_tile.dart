import 'package:flutter/material.dart';
import '../common.dart';
import '../options/theme/_filelist_theme.dart';
import 'shortcut.dart';

/// A single row displaying a file system shortcut, the corresponding icon and the trailing
/// selection button.
///
/// Used in conjunction with the `FilesystemShortcutsListView` widget.
class FilesystemShortcutListTile extends StatelessWidget {
  final FilesystemPickerShortcut shortcut;
  final ValueChanged<FilesystemPickerShortcut> onChange;
  final ValueChanged<FilesystemPickerShortcut> onSelect;
  final FilesystemPickerFileListThemeData? theme;
  final FilesystemType fsType;

  const FilesystemShortcutListTile({
    super.key,
    required this.shortcut,
    required this.onChange,
    required this.onSelect,
    required this.fsType,
    this.theme,
  });

  Widget _leading(
      BuildContext context, FilesystemPickerFileListThemeData theme) {
    return Icon(
      shortcut.icon ?? theme.getShortcutIcon(context),
      color: theme.getShortcutIconColor(context),
      size: theme.getIconSize(context),
    );
  }

  Widget? _trailing(
      BuildContext context, FilesystemPickerFileListThemeData theme) {
    if (fsType != FilesystemType.file && shortcut.isSelectable) {
      final iconTheme = theme.getCheckIconTheme(context);
      return InkResponse(
        child: Icon(
          theme.getCheckIcon(context),
          color: iconTheme.color,
          size: iconTheme.size,
        ),
        onTap: () => onSelect(shortcut),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? FilesystemPickerFileListThemeData();
    final style = effectiveTheme.getShortcutTextStyle(context);

    return ListTile(
      key: Key(shortcut.path.path),
      leading: _leading(context, effectiveTheme),
      trailing: _trailing(context, effectiveTheme),
      title: Text(shortcut.name,
          style: style,
          textScaleFactor: effectiveTheme.getTextScaleFactor(context, false)),
      onTap: () => onChange(shortcut),
    );
  }
}
