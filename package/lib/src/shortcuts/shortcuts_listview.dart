import 'package:flutter/material.dart';
import 'shortcuts.dart';
import 'shortcuts_list_tile.dart';
import '../options/theme/_filelist_theme.dart';

class FilesystemShortcutsListView extends StatelessWidget {
  final List<FilesystemShortcut> shortcuts;
  final ScrollController? scrollController;
  final FilesystemPickerFileListThemeData? theme;
  final ValueChanged<FilesystemShortcut> onChange;

  const FilesystemShortcutsListView({
    super.key,
    required this.shortcuts,
    this.scrollController,
    this.theme,
    required this.onChange,
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
        onSelect: onChange,
      ),
    );
  }
}
