import 'package:flutter/material.dart';
import '../common.dart';
import 'shortcut.dart';
import 'shortcuts_list_tile.dart';
import '../options/theme/_filelist_theme.dart';

/// A widget that displays a list of file system shortcuts.
class FilesystemShortcutsListView extends StatelessWidget {
  final List<FilesystemPickerShortcut> shortcuts;
  final ScrollController? scrollController;
  final FilesystemPickerFileListThemeData? theme;
  final FilesystemType fsType;
  final ValueChanged<FilesystemPickerShortcut> onChange;
  final ValueChanged<FilesystemPickerShortcut> onSelect;

  const FilesystemShortcutsListView({
    super.key,
    required this.shortcuts,
    this.scrollController,
    this.theme,
    required this.fsType,
    required this.onChange,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? FilesystemPickerFileListThemeData();

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: shortcuts.length,
      itemBuilder: (context, index) => FilesystemShortcutListTile(
        shortcut: shortcuts[index],
        theme: effectiveTheme,
        fsType: fsType,
        onChange: onChange,
        onSelect: onSelect,
      ),
    );
  }
}
