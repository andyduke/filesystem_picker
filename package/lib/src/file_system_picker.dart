import 'dart:async';
import 'dart:io';

import 'package:filesystem_picker/src/constants/enums/file_system_type.dart';
import 'package:filesystem_picker/src/constants/typedefs/typedefs.dart';
import 'package:filesystem_picker/src/utils/helpers/file_icon_helper.dart';
import 'package:filesystem_picker/src/utils/models/breadcrumb_item.dart';
import 'package:filesystem_picker/src/utils/models/file_system_mini_item.dart';
import 'package:filesystem_picker/src/utils/models/path_item.dart';
import 'package:filesystem_picker/src/utils/models/root_info.dart';
import 'package:filesystem_picker/src/utils/models/stack_list.dart';
import 'package:filesystem_picker/src/widgets/breadcrumbs.dart';
import 'package:filesystem_picker/src/widgets/file_system_list.dart';
import 'package:filesystem_picker/src/widgets/filename_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as pt;

/// FileSystem file or folder picker dialog.
///
/// Allows the user to browse the file system and pick a folder or file.
///
/// See also:
///
///  * [FilesystemPicker.open]
class FilesystemPicker extends StatefulWidget {
  /// Open FileSystemPicker dialog
  ///
  /// Returns null if nothing was selected.
  ///
  /// * [rootDirectories] specifies one or more roots of the filesystem view.
  /// * [rootNames] specifies the name of each filesystem view root in breadcrumbs, by default "Storage". Assign empty string to use default name for specific root.
  /// * [fsType] specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  /// * [pickText] specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  /// * [permissionText] specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  /// * [title] specifies the text of the dialog title.
  /// * [allowedExtensions] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`
  /// * [fileTileSelectMode] specifies how to files can be selected (either tapping on the whole tile or only on trailing button). (default depends on [fsType])
  /// * [requestPermission] if specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  static Future<Iterable<String>?> open({
    required BuildContext context,
    required List<Directory> rootDirectories,
    List<String>? rootNames,
    FilesystemType fsType = FilesystemType.all,
    bool multiSelect = false,
    String? pickText = 'Select',
    String? cancelText = 'Cancel',
    String? permissionText,
    String? title,
    Color? folderIconColor,
    List<String>? allowedExtensions,
    RequestPermission? requestPermission,
    ThemeData? themeData,
    TextDirection? textDirection,
  }) async {
    return Navigator.of(context).push<Iterable<String>>(
      MaterialPageRoute(builder: (BuildContext context) {
        return FilesystemPicker(
          rootDirectories: rootDirectories,
          rootNames: rootNames,
          fsType: fsType,
          multiSelect: multiSelect,
          pickText: pickText,
          cancelText: cancelText,
          permissionText: permissionText,
          title: title,
          folderIconColor:
              folderIconColor ?? (themeData ?? Theme.of(context)).primaryColor,
          allowedExtensions: allowedExtensions,
          requestPermission: requestPermission,
          themeData: themeData,
          textDirection: textDirection,
        );
      }),
    );
  }

  // ---

  final List<Directory> rootDirectories;
  final List<String>? rootNames;
  final FilesystemType fsType;
  final bool multiSelect;
  final String? pickText;
  final String? cancelText;
  final String? permissionText;
  final String? title;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final RequestPermission? requestPermission;
  final ThemeData? themeData;
  final TextDirection? textDirection;

  FilesystemPicker({
    Key? key,
    required this.rootDirectories,
    this.rootNames,
    this.fsType = FilesystemType.all,
    this.multiSelect = false,
    this.pickText,
    this.cancelText,
    this.permissionText,
    this.title,
    this.folderIconColor,
    this.allowedExtensions,
    this.requestPermission,
    this.themeData,
    this.textDirection,
  }) : super(key: key);

  @override
  _FilesystemPickerState createState() => _FilesystemPickerState();
}

class _FilesystemPickerState extends State<FilesystemPicker> {
  bool permissionRequesting = true;
  bool permissionAllowed = false;
  bool loadingFSE = true;
  bool toggleSelectAll = false;

  final List<FileSystemMiniItem> items = [];
  final StackList<Directory> history = StackList<Directory>();
  final Map<String, FileSystemEntityType> selectedPaths =
      <String, FileSystemEntityType>{};

  final List<RootInfo> _roots = [];
  Directory? directory;
  String? directoryName;
  final List<PathItem> pathItems = [];

  RootInfo? rootDirectory;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _requestPermission();
      if (widget.rootDirectories.isEmpty) {
        throw Exception("rootDirectories can't be empty.");
      } else {
        _createRoots();
        rootDirectory = _roots.first;
        _setDirectory(rootDirectory!.directory);
      }
    });
  }

  Future<void> _requestPermission() async {
    final requestPermission = widget.requestPermission;
    if (requestPermission == null || await requestPermission()) {
      permissionAllowed = true;
    }

    permissionRequesting = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _createRoots() async {
    _roots.clear();
    for (var i = 0; i < widget.rootDirectories.length; i++) {
      var root = widget.rootDirectories[i];
      var label = widget.rootNames != null &&
              widget.rootNames!.length > i &&
              widget.rootNames![i].isNotEmpty
          ? widget.rootNames![i]
          : pt.basename(root.absolute.path);
      _roots.add(RootInfo(root, label));
    }
  }

  void _setDirectory(Directory? value) {
    setState(() {
      loadingFSE = true;
    });

    directory = value;

    var dirPath =
        pt.relative(directory!.path, from: pt.dirname(rootDirectory!.path));
    final items = dirPath.split(Platform.pathSeparator);
    pathItems.clear();

    var rootItem = items.first;
    var rootPath =
        pt.dirname(rootDirectory!.path) + Platform.pathSeparator + rootItem;
    pathItems.add(PathItem(path: rootPath, text: rootDirectory!.label));
    items.removeAt(0);

    var path = rootPath;

    for (var item in items) {
      path += Platform.pathSeparator + item;
      pathItems.add(PathItem(path: path, text: item));
    }

    directoryName = ((directory!.path == rootDirectory!.path))
        ? rootDirectory!.label
        : pt.basename(directory!.path);

    setState(() {
      loadingFSE = false;
    });
  }

  // change directory and put the previous directory into history stack
  void _changeDirectory(Directory value) {
    if (directory!.absolute.path != value.absolute.path) {
      toggleSelectAll = false;
      history.push(directory!);
      _setDirectory(value);
      if (widget.multiSelect == false) {
        selectedPaths.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackAction,
      child: Builder(
        builder: (_) => Theme(
            data: widget.themeData ?? Theme.of(context),
            child: Directionality(
              textDirection: widget.textDirection ?? Directionality.of(context),
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(widget.title ?? directoryName!),
                    leading: Builder(
                      builder: (ctx) {
                        return IconButton(
                          icon: Icon(widget.rootDirectories.length > 1 ||
                                  widget.multiSelect
                              ? Icons.menu
                              : Icons.close),
                          onPressed: () {
                            if (widget.rootDirectories.length > 1 ||
                                widget.multiSelect) {
                              Scaffold.of(ctx).openDrawer();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      },
                    ),
                    actions: selectedPaths.isNotEmpty && widget.multiSelect
                        ? [
                            IconButton(
                                tooltip: 'Select/Unselect All',
                                icon: Icon(Icons.select_all),
                                onPressed: () {
                                  items.forEach((p) {
                                    if (widget.fsType == FilesystemType.all ||
                                        (widget.fsType == FilesystemType.file &&
                                            p.type ==
                                                FileSystemEntityType.file) ||
                                        (widget.fsType ==
                                                FilesystemType.folder &&
                                            p.type ==
                                                FileSystemEntityType
                                                    .directory)) {
                                      if (toggleSelectAll == false) {
                                        selectedPaths[p.absolutePath] = p.type;
                                      } else {
                                        selectedPaths.remove(p.absolutePath);
                                      }
                                    }
                                  });

                                  setState(() {
                                    toggleSelectAll = !toggleSelectAll;
                                  });
                                })
                          ]
                        : null,
                    bottom: _buildBreadCrumb(context),
                  ),
                  drawerEnableOpenDragGesture: false,
                  drawer:
                      widget.rootDirectories.length > 1 || widget.multiSelect
                          ? _buildDrawer(context)
                          : null,
                  body: _buildBody(context),
                  bottomNavigationBar: _buildBottomButtons(context)),
            )),
      ),
    );
  }

  PreferredSizeWidget _buildBreadCrumb(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Theme(
        data: ThemeData(
          textTheme: TextTheme(
            button: TextStyle(
              color: AppBarTheme.of(context).textTheme?.headline6?.color ??
                  (widget.themeData ?? Theme.of(context))
                      .primaryTextTheme
                      .headline6
                      ?.color,
            ),
          ),
        ),
        child: Breadcrumbs<String>(
          items: (!permissionRequesting && permissionAllowed)
              ? pathItems
                  .map((path) => BreadcrumbItem<String>(
                        text: path.text,
                        data: path.path,
                      ))
                  .toList(growable: false)
              : [],
          onSelect: (String? value) {
            _changeDirectory(Directory(value!));
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: widget.rootDirectories.length > 1,
            child: Material(
              color: (widget.themeData ?? Theme.of(context)).primaryColor,
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: ListTile(
                    title: Text('Select Directory',
                        style: (widget.themeData ?? Theme.of(context))
                            .primaryTextTheme
                            .headline6),
                    leading: Icon(Icons.storage,
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Visibility(
              visible: widget.rootDirectories.length > 1,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _roots.length,
                itemBuilder: (_, index) {
                  var r = _roots.elementAt(index);
                  return RadioListTile<int>(
                    secondary: selectedPaths.keys
                            .any((ee) => ee.startsWith(r.absolutePath))
                        ? Icon(Icons.library_add_check,
                            color: (widget.themeData ?? Theme.of(context))
                                .primaryColorDark)
                        : null,
                    title: Text(r.label.toUpperCase()),
                    value: _roots.indexOf(r),
                    groupValue: _roots
                        .map((e) => e.absolutePath)
                        .toList()
                        .indexOf(rootDirectory!.absolutePath),
                    onChanged: (val) {
                      rootDirectory = _roots[val!];
                      if (widget.multiSelect == false) {
                        selectedPaths.clear();
                      }
                      _setDirectory(rootDirectory!.directory);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: widget.multiSelect,
            child: Material(
              color: (widget.themeData ?? Theme.of(context)).primaryColor,
              child: ListTile(
                leading: Icon(Icons.library_add_check,
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
                title: Text(
                  'Selected ' +
                      (widget.fsType == FilesystemType.all
                          ? 'Items'
                          : widget.fsType == FilesystemType.file
                              ? 'Files'
                              : 'Folders') +
                      ' (' +
                      selectedPaths.length.toString() +
                      ')',
                  style: (widget.themeData ?? Theme.of(context))
                      .primaryTextTheme
                      .headline6,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Visibility(
              visible: widget.multiSelect,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: selectedPaths.length,
                separatorBuilder: (_, index) =>
                    Divider(color: Colors.grey, height: 1),
                itemBuilder: (_, index) {
                  var pathString = selectedPaths.keys.elementAt(index);
                  var fseType = selectedPaths.values.elementAt(index);
                  return ListTile(
                    leading: fseType == FileSystemEntityType.file
                        ? FileIconHelper.getIcon(
                            pathString,
                            (widget.themeData ?? Theme.of(context))
                                .primaryColor)
                        : Icon(
                            Icons.folder,
                            color: widget.folderIconColor ??
                                (widget.themeData ?? Theme.of(context))
                                    .primaryColor,
                            size: FileIconHelper.iconSize,
                          ),
                    title: FilenameText(
                      pathString,
                      isDirectory: fseType == FileSystemEntityType.directory,
                    ),
                    onTap: () {
                      if (pathString.startsWith(rootDirectory!.absolutePath) ==
                          false) {
                        rootDirectory = _roots.firstWhere(
                            (ss) => pathString.startsWith(ss.absolutePath));
                      }
                      _changeDirectory(Directory(
                          pathString == rootDirectory!.absolutePath
                              ? pathString
                              : pt.dirname(pathString)));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 1,
            color: (widget.themeData ?? Theme.of(context)).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (permissionRequesting || loadingFSE || rootDirectory == null) {
      return Center(child: CircularProgressIndicator());
    } else if (permissionAllowed == false) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(
            widget.permissionText ?? 'Access to the storage was not granted.',
            textScaleFactor: 1.2),
      );
    }

    return FilesystemList(
        items: items,
        isRoot: (directory!.absolute.path == rootDirectory!.absolutePath),
        rootDirectory: directory!,
        multiSelect: widget.multiSelect,
        fsType: widget.fsType,
        folderIconColor: widget.folderIconColor,
        allowedExtensions: widget.allowedExtensions,
        onChange: _changeDirectory,
        selectedItems: selectedPaths.keys,
        themeData: widget.themeData,
        textDirection: widget.textDirection,
        onSelect: (path, isSelected, itemType) {
          setState(() {
            if (widget.multiSelect == false) {
              selectedPaths.clear();
              selectedPaths[path] = itemType;
            } else {
              if (isSelected) {
                selectedPaths.remove(path);
              } else {
                selectedPaths[path] = itemType;
              }
            }
          });
        });
  }

  Widget _buildBottomButtons(BuildContext context) {
    return BottomAppBar(
      color: (widget.themeData ?? Theme.of(context)).primaryColor,
      child: Container(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: AppBarTheme.of(context).textTheme?.headline6?.color ??
                    Theme.of(context).primaryTextTheme.headline6?.color,
              ),
              icon: Icon(Icons.cancel),
              label: (widget.cancelText != null)
                  ? Text(widget.cancelText!)
                  : const Text('Cancel'),
              onPressed: (!permissionRequesting && permissionAllowed)
                  ? () {
                      cancelButtonPressed = true;
                      Navigator.pop(context);
                    }
                  : null,
            )),
            VerticalDivider(
              width: 1,
              color: (widget.themeData ?? Theme.of(context)).accentColor,
            ),
            Expanded(
                child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: AppBarTheme.of(context).textTheme?.headline6?.color ??
                    Theme.of(context).primaryTextTheme.headline6?.color,
              ),
              icon: Icon(Icons.check_circle),
              label: (widget.pickText != null)
                  ? Text(widget.pickText!)
                  : const Text('Select'),
              onPressed: (!permissionRequesting &&
                      permissionAllowed &&
                      selectedPaths.isNotEmpty)
                  ? () => Navigator.pop(context, selectedPaths.keys)
                  : null,
            ))
          ],
        ),
      ),
    );
  }

  bool cancelButtonPressed = false;

  Future<bool> _handleBackAction() {
    if (cancelButtonPressed == false &&
        history.length > 0 &&
        (widget.rootDirectories.length > 1 ||
            directory!.absolute.path != rootDirectory!.absolutePath)) {
      var p = history.pop();
      if (p.absolute.path.startsWith(rootDirectory!.absolutePath) == false) {
        rootDirectory = _roots
            .firstWhere((ss) => p.absolute.path.startsWith(ss.absolutePath));
      }

      toggleSelectAll = false;
      _setDirectory(p);
      if (widget.multiSelect == false) {
        selectedPaths.clear();
      }
      return Future.value(false);
    }

    // if on root OR history is empty OR cancel btn pressed, close picker
    return Future.value(true);
  }
}
