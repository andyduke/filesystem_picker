import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list_tile.dart';
import 'options/theme/_filelist_theme.dart';

class FilesystemList extends StatelessWidget {
  final bool isRoot;
  final Directory rootDirectory;
  final FilesystemType fsType;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final FileTileSelectMode fileTileSelectMode;
  final FilesystemPickerFileListThemeData? theme;
  final bool showGoUpItem;

  FilesystemList({
    Key? key,
    this.isRoot = false,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onChange,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.theme,
    this.showGoUpItem = true,
  }) : super(key: key);

  Future<List<FileSystemEntity>> _dirContents() {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    var lister = this.rootDirectory.list(recursive: false);
    lister.listen(
      (file) {
        if ((fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) && (allowedExtensions != null) && (allowedExtensions!.length > 0)) {
            if (!allowedExtensions!.contains(Path.extension(file.path))) return;
          }
          files.add(file);
        }
      },
      onDone: () {
        files.sort((a, b) => a.path.compareTo(b.path));
        completer.complete(files);
      },
    );
    return completer.future;
  }

  InkWell _upNavigation(BuildContext context, FilesystemPickerFileListThemeData theme) {
    final iconTheme = theme.getUpIconTheme(context);

    return InkWell(
      child: ListTile(
        leading: Icon(
          theme.getUpIcon(context),
          size: iconTheme.size,
          color: iconTheme.color,
        ),
        title: Text(
          theme.getUpText(context),
          style: theme.getUpTextStyle(context),
          textScaleFactor: theme.getUpTextScaleFactor(context),
        ),
      ),
      onTap: () {
        final li = this.rootDirectory.path.split(Platform.pathSeparator)..removeLast();
        onChange(Directory(li.join(Platform.pathSeparator)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dirContents(),
      builder: (BuildContext context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        final effectiveTheme = theme ?? FilesystemPickerFileListThemeData();

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('Error loading file list: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length + (showGoUpItem ? (isRoot ? 0 : 1) : 0),
              itemBuilder: (BuildContext context, int index) {
                if (showGoUpItem && !isRoot && index == 0) {
                  return _upNavigation(context, effectiveTheme);
                }

                final item = snapshot.data![index - (showGoUpItem ? (isRoot ? 0 : 1) : 0)];
                return FilesystemListTile(
                  fsType: fsType,
                  item: item,
                  folderIconColor: folderIconColor,
                  onChange: onChange,
                  onSelect: onSelect,
                  fileTileSelectMode: fileTileSelectMode,
                  theme: effectiveTheme,
                );
              },
            );
          } else {
            return const SizedBox();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: effectiveTheme.getProgressIndicatorColor(context),
            ),
          );
        }
      },
    );
  }
}
