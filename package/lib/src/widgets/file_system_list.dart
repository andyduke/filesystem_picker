import 'dart:async';
import 'dart:io';

import 'package:filesystem_picker/src/utils/models/file_system_mini_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../constants/enums/file_system_type.dart';
import '../constants/typedefs/typedefs.dart';
import 'filesystem_list_tile.dart';

class FilesystemList extends StatelessWidget {
  final List<FileSystemMiniItem> items;
  final bool isRoot;
  final Directory rootDirectory;
  final FilesystemType fsType;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final Iterable<String> selectedItems;
  final bool multiSelect;
  final ThemeData? themeData;
  final TextDirection? textDirection;

  FilesystemList({
    Key? key,
    required this.items,
    this.isRoot = false,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onChange,
    required this.onSelect,
    required this.selectedItems,
    this.multiSelect = false,
    this.themeData,
    this.textDirection,
  }) : super(key: key);

  Future<List<FileSystemEntity>> _getDirContents() {
    var items = <FileSystemEntity>[];

    var completer = Completer<List<FileSystemEntity>>();
    var lister = rootDirectory.list(recursive: false);
    lister.listen(
      (file) {
        if ((fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) &&
              (allowedExtensions != null) &&
              (allowedExtensions!.isNotEmpty)) {
            if (!allowedExtensions!.contains(path.extension(file.path))) return;
          }
          items.add(file);
        }
      },
      onDone: () {
        items.sort((a, b) => a.path.compareTo(b.path));
        completer.complete(items);
      },
    );
    return completer.future;
  }

  InkWell _topNavigation() {
    return InkWell(
      onTap: () {
        final li = rootDirectory.path.split(Platform.pathSeparator)
          ..removeLast();
        onChange(Directory(li.join(Platform.pathSeparator)));
      },
      child: const ListTile(
        leading: Icon(Icons.arrow_upward, size: 32),
        title: Text('...', textScaleFactor: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDirContents(),
      builder: (BuildContext context,
          AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        items.clear();
        if (snapshot.hasData) {
          var chs = <Widget>[];

          if (!isRoot) {
            chs.add(_topNavigation()); // up/back one level
            chs.add(Divider(color: Colors.grey, height: 1));
          }

          if (snapshot.data!.isNotEmpty) {
            //List<FileSystemEntity> symbolicLinks = [];
            var dirs = <FileSystemEntity>[];
            var files = <FileSystemEntity>[];
            snapshot.data!.forEach((fse) {
              if (fse is File) {
                files.add(fse);
              } else if (fse is Directory) {
                dirs.add(fse);
              }
              // else if (fse is Link) {
              //   symbolicLinks.add(fse);
              // }
            });

            //symbolicLinks.followedBy(dirs).
            dirs.followedBy(files).forEach((fse) {
              chs.add(
                FilesystemListTile(
                  fsType: fsType,
                  item: fse,
                  folderIconColor: folderIconColor,
                  onChange: onChange,
                  onSelect: onSelect,
                  isSelected: selectedItems.contains(fse.absolute.path),
                  subItemsSelected: selectedItems.any((ee) => ee
                      .startsWith(fse.absolute.path + Platform.pathSeparator)),
                  multiSelect: multiSelect,
                  themeData: themeData,
                  textDirection: textDirection,
                ),
              );
              chs.add(Divider(color: Colors.grey, height: 1));
              items.add(
                FileSystemMiniItem(
                    fse.absolute.path,
                    fse is File
                        ? FileSystemEntityType.file
                        : fse is Directory
                            ? FileSystemEntityType.directory
                            : FileSystemEntityType.notFound),
              );
            });
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            semanticChildCount: chs.length,
            children: chs,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
