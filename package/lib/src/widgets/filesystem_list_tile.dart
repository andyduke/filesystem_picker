import 'dart:io';

import 'package:filesystem_picker/src/constants/enums/file_system_type.dart';
import 'package:filesystem_picker/src/constants/typedefs/typedefs.dart';
import 'package:filesystem_picker/src/utils/helpers/file_icon_helper.dart';
import 'package:filesystem_picker/src/widgets/filename_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilesystemListTile extends StatelessWidget {
  final FilesystemType fsType;
  final FileSystemEntity item;
  final Color? folderIconColor;
  final ValueChanged<Directory> onChange;
  final bool multiSelect;
  final bool isSelected;
  final bool subItemsSelected;
  final ValueSelected onSelect;
  final ThemeData? themeData;
  final TextDirection? textDirection;

  FilesystemListTile(
      {Key? key,
      this.fsType = FilesystemType.all,
      required this.item,
      this.folderIconColor,
      required this.onChange,
      required this.multiSelect,
      required this.isSelected,
      required this.subItemsSelected,
      required this.onSelect,
      this.themeData,
      this.textDirection})
      : super(key: key);

  Widget _leading(BuildContext context) {
    Icon ic;
    var col = isSelected
        ? (themeData ?? Theme.of(context)).primaryColorLight
        : (item is File
            ? (themeData ?? Theme.of(context)).unselectedWidgetColor
            : (folderIconColor ?? (themeData ?? Theme.of(context)).primaryColor));
    if (item is Directory) {
      ic = Icon(
        Icons.folder,
        color: col,
        size: FileIconHelper.iconSize,
      );
    } else {
      ic = FileIconHelper.getIcon(item.path, col);
    }

    return ic;
  }

  Widget _trailing(BuildContext context) {
    var chs = <Widget>[];
    if (subItemsSelected && item is Directory) {
      chs.add(Icon(Icons.library_add_check,
          color: (themeData ?? Theme.of(context)).primaryColorDark));
    }

    if ((item is File && fsType == FilesystemType.file && multiSelect) ||
        (item is Directory && fsType == FilesystemType.folder)) {
      chs.add(InkResponse(
        onTap: () => onSelect(
            item.absolute.path,
            isSelected,
            item is File
                ? FileSystemEntityType.file
                : item is Directory
                    ? FileSystemEntityType.directory
                    : FileSystemEntityType.notFound),
        child: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected
              ? (themeData ?? Theme.of(context)).primaryColorLight
              : (themeData ?? Theme.of(context)).disabledColor.withOpacity(0.5),
        ),
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
    var tx = FilenameText(
      item.path,
      isDirectory: item is Directory,
      textStyle: isSelected
          ? (themeData ?? Theme.of(context)).primaryTextTheme.bodyText1
          : (themeData ?? Theme.of(context)).textTheme.bodyText1,
    );

    return tx;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key(item.absolute.path),
      color: isSelected ? (themeData ?? Theme.of(context)).primaryColorDark : Colors.transparent,
      child: InkWell(
          onTap: () {
            if (item is Directory) {
              onChange(item as Directory);
            } else if (item is File) {
              onSelect(
                  item.absolute.path, isSelected, FileSystemEntityType.file);
            }
          },
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
          )),
    );
  }
}
