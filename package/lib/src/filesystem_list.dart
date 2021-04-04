import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list_tile.dart';

class ItemMini {
  final String absolutePath;
  final FileSystemEntityType type;

  ItemMini(this.absolutePath, this.type);
}

class FileSystemListController {
  final List<ItemMini> items = <ItemMini>[];
}

class FilesystemList extends StatelessWidget {
  final FileSystemListController controller;
  final bool isRoot;
  final Directory rootDirectory;
  final FilesystemType fsType;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final Iterable<String> selectedItems;
  final bool multiSelect;

  FilesystemList({
    Key? key,
    required this.controller,
    this.isRoot = false,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onChange,
    required this.onSelect,
    required this.selectedItems,
    this.multiSelect = false,
  }) : super(key: key);

  Future<List<FileSystemEntity>> _dirContents() {
    var items = <FileSystemEntity>[];

    var completer = new Completer<List<FileSystemEntity>>();
    var lister = this.rootDirectory.list(recursive: false);
    lister.listen(
          (file) {
        if ((fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) &&
              (allowedExtensions != null) &&
              (allowedExtensions!.length > 0)) {
            if (!allowedExtensions!.contains(Path.extension(file.path))) return;
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
      child: const ListTile(
        leading: Icon(Icons.arrow_upward, size: 32),
        title: Text("...", textScaleFactor: 1.5),
      ),
      onTap: () {
        final li = this.rootDirectory.path.split(Platform.pathSeparator)
          ..removeLast();
        onChange(Directory(li.join(Platform.pathSeparator)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dirContents(),
      builder: (BuildContext context,
          AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        controller.items.clear();
        if (snapshot.hasData && snapshot.data!.length >= 0) {
          List<Widget> chs = [];

          if (!isRoot) {
            chs.add(_topNavigation()); // up/back one level
            chs.add(fseHBorder);
          }

          if (snapshot.data!.length > 0) {
            //List<FileSystemEntity> symbolicLinks = [];
            List<FileSystemEntity> dirs = [];
            List<FileSystemEntity> files = [];
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
              chs.add(FilesystemListTile(
                fsType: fsType,
                item: fse,
                folderIconColor: folderIconColor,
                onChange: onChange,
                onSelect: onSelect,
                isSelected: selectedItems.contains(fse.absolute.path),
                subItemsSelected: selectedItems.any((ee) =>
                    ee.startsWith(fse.absolute.path + Platform.pathSeparator)),
                multiSelect: multiSelect,
              ));
              chs.add(fseHBorder);
              controller.items.add(ItemMini(fse.absolute.path,
                  fse is File ? FileSystemEntityType.file : fse is Directory
                      ? FileSystemEntityType.directory
                      : FileSystemEntityType.notFound));
            });
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            semanticChildCount: chs.length,
            children: chs,
          );

        } else {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
