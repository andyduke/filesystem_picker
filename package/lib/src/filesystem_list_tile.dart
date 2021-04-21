import 'dart:io';
import 'package:filesystem_picker/src/filename_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'common.dart';

class FilesystemListTile extends StatelessWidget {
  final FilesystemType fsType;
  final FileSystemEntity item;
  final Color? folderIconColor;
  final ValueChanged<Directory> onChange;
  final bool multiSelect;
  final bool isSelected;
  final bool subItemsSelected;
  final ValueSelected onSelect;

  FilesystemListTile(
      {Key? key,
      this.fsType = FilesystemType.all,
      required this.item,
      this.folderIconColor,
      required this.onChange,
      required this.multiSelect,
      required this.isSelected,
      required this.subItemsSelected,
      required this.onSelect})
      : super(key: key);

  Widget _leading(BuildContext context) {
    Icon ic;
    Color col = isSelected
        ? Theme.of(context).primaryColorLight
        : (item is File
            ? Theme.of(context).unselectedWidgetColor
            : (folderIconColor ?? Theme.of(context).primaryColor));
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
          onTap: () => onChange(item as Directory));
    } else {
      return ic;
    }
  }

  Widget _trailing(BuildContext context) {
    var chs = <Widget>[];
    if (subItemsSelected && item is Directory) {
      chs.add(Icon(Icons.library_add_check,
          color: Theme.of(context).primaryColorDark));
    }

    if ((item is File && fsType == FilesystemType.file && multiSelect) ||
        (item is Directory && fsType == FilesystemType.folder)) {
      chs.add(InkResponse(
        child: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).disabledColor.withOpacity(0.5),
        ),
        onTap: () => onSelect(
            item.absolute.path,
            isSelected,
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
      return Container();
    }
  }

  Widget _main(BuildContext context) {
    var tx = FilenameTextWidget(
        item.path,
        isDirectory: item is Directory,
        textStyle: isSelected
            ? Theme.of(context).primaryTextTheme.bodyText1
            : Theme.of(context).textTheme.bodyText1,
    );
    if (item is Directory) {
      return GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: tx,
          ),
          onTap: () => onChange(item as Directory));
    } else {
      return tx;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key(item.absolute.path),
      color: isSelected ? Theme.of(context).primaryColorDark : Colors.transparent,
      child: InkWell(
          child: SizedBox(
            height: 60,
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: _leading(context),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: _main(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: _trailing(context),
                )
              ],
            ),
          ),
          onTap: (item is Directory && fsType == FilesystemType.file)
              ? () => onChange(item as Directory)
              : (fsType == FilesystemType.file
              ? () => onSelect(
              item.absolute.path,
              isSelected,
              item is File
                  ? FileSystemEntityType.file
                  : item is Directory
                  ? FileSystemEntityType.directory
                  : FileSystemEntityType.notFound)
              : null)),
    );
  }
}
