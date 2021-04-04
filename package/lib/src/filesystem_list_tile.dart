import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'common.dart';
import 'package:path/path.dart' as Path;

class FilesystemListTile extends StatelessWidget {
  final FilesystemType fsType;
  final FileSystemEntity item;
  final Color? folderIconColor;
  final ValueChanged<Directory> onChange;
  final bool multiSelect;
  final bool isSelected;
  final bool subItemsSelected;
  final ValueSelected onSelect;

  FilesystemListTile({
    Key? key,
    this.fsType = FilesystemType.all,
    required this.item,
    this.folderIconColor,
    required this.onChange,
    required this.multiSelect,
    required this.isSelected,
    required this.subItemsSelected,
    required this.onSelect
  }) : super(key: key);

  Widget _leading(BuildContext context) {
    Icon ic;
    Color col = isSelected ? Theme
        .of(context)
        .primaryColorLight : (item is File ? Theme
        .of(context)
        .unselectedWidgetColor : (folderIconColor ?? Theme
        .of(context)
        .primaryColor));
    if (item is Directory) {
      ic = Icon(
        Icons.folder,
        color: col,
        size: iconSize,
      );
    } else {
      ic = fileIcon(item.path, col);
    }

    if (multiSelect && item is Directory) {
      return GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: ic,
          ),
          onTap: () => onChange(item as Directory)
      );
    } else {
      return ic;
    }
  }

  Widget? _trailing(BuildContext context) {
    var chs = <Widget>[];
    if (subItemsSelected && item is Directory) {
      chs.add(Icon(Icons.library_add_check, color: Theme
          .of(context)
          .primaryColorDark));
    }

    if ((item is File && fsType == FilesystemType.file && multiSelect) ||
        (item is Directory && fsType == FilesystemType.folder)) {
      chs.add(InkResponse(
        child: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected ? Theme
              .of(context)
              .primaryColorLight : Theme
              .of(context)
              .disabledColor
              .withOpacity(0.5),
        ),
        onTap: () =>
            onSelect(item.absolute.path, isSelected,
                item is File
                    ? FileSystemEntityType.file
                    : item is Directory
                    ? FileSystemEntityType.directory
                    : FileSystemEntityType.notFound),
      ));
    }

    if (chs.isNotEmpty) {
      var children = <Widget>[];
      chs.forEach((element) {
        children.add(element);
        children.add(Container(width: 10));
      });
      children.removeLast();

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    } else {
      return null;
    }
  }

  Widget _main(BuildContext context) {
    var tx = Text(Path.basename(item.path), textScaleFactor: 1.2,
        style: isSelected && item is File ? Theme
            .of(context)
            .primaryTextTheme
            .bodyText1 : Theme
            .of(context)
            .textTheme
            .bodyText1);
    if (item is Directory) {
      return GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: tx,
          ),
          onTap: () => onChange(item as Directory)
      );
    } else {
      return tx;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: Key(item.absolute.path),
        selected: isSelected,
        selectedTileColor: Theme
            .of(context)
            .primaryColor,
        leading: _leading(context),
        trailing: _trailing(context),
        title: _main(context),
        onTap: (item is Directory && fsType == FilesystemType.file)
            ? () => onChange(item as Directory)
            : (fsType == FilesystemType.file
            ? () =>
            onSelect(item.absolute.path, isSelected,
                item is File
                    ? FileSystemEntityType.file
                    : item is Directory
                    ? FileSystemEntityType.directory
                    : FileSystemEntityType.notFound)
            : null)
    );
  }
}
