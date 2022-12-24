import 'package:filesystem_picker/src/shortcuts/shortcuts.dart';
import 'package:flutter/material.dart';
import '../options/theme/_filelist_theme.dart';

class FilesystemShortcutListTile extends StatelessWidget {
  final FilesystemShortcut shortcut;
  final ValueChanged<FilesystemShortcut> onChange;
  final ValueChanged<FilesystemShortcut> onSelect;
  final FilesystemPickerFileListThemeData? theme;

  const FilesystemShortcutListTile({
    super.key,
    required this.shortcut,
    required this.onChange,
    required this.onSelect,
    this.theme,
  });

  Widget _leading(BuildContext context, FilesystemPickerFileListThemeData theme) {
    return Icon(
      shortcut.icon ?? theme.getFolderIcon(context),
      color: theme.getFolderIconColor(context),
      size: theme.getIconSize(context),
    );
  }

  Widget? _trailing(BuildContext context, FilesystemPickerFileListThemeData theme) {
    final iconTheme = theme.getCheckIconTheme(context);
    return InkResponse(
      child: Icon(
        theme.getCheckIcon(context),
        color: iconTheme.color,
        size: iconTheme.size,
      ),
      onTap: () => onSelect(shortcut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? FilesystemPickerFileListThemeData();
    final style = effectiveTheme.getFolderTextStyle(context); // TODO: Replace with getShortcutTextStyle

    return ListTile(
      key: Key(shortcut.path.path),
      leading: _leading(context, effectiveTheme),
      trailing: _trailing(context, effectiveTheme),
      title: Text(shortcut.name,
          style: style, textScaleFactor: effectiveTheme.getTextScaleFactor(context, false /* TODO: !!! */)),
      onTap: () => onChange(shortcut),
    );
  }
}
