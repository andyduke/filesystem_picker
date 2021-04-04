import 'dart:async';
import 'dart:io';
import 'package:filesystem_picker/src/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'common.dart';
import 'filesystem_list.dart';
import 'package:path/path.dart' as Path;
import 'breadcrumbs.dart';

class _PathItem {
  final String text;
  final String path;

  _PathItem({
    required this.path,
    required this.text,
  });

  @override
  String toString() {
    return '$text: $path';
  }
}

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
  /// * [rootDirectory] specifies the root of the filesystem view.
  /// * [rootName] specifies the name of the filesystem view root in breadcrumbs, by default "Storage".
  /// * [fsType] specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  /// * [pickText] specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  /// * [permissionText] specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  /// * [title] specifies the text of the dialog title.
  /// * [allowedExtensions] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`
  /// * [fileTileSelectMode] specifies how to files can be selected (either tapping on the whole tile or only on trailing button). (default depends on [fsType])
  /// * [requestPermission] if specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  static Future<Iterable<String>?> open({
    required BuildContext context,
    Directory? fixedRootDirectory,
    String? fixedRootName,
    FilesystemType fsType = FilesystemType.all,
    bool multiSelect = false,
    String? pickText = "Select",
    String? cancelText = "Cancel",
    String? permissionText,
    String? title,
    Color? folderIconColor,
    List<String>? allowedExtensions,
    RequestPermission? requestPermission,
  }) async {
    return Navigator.of(context).push<Iterable<String>>(
      MaterialPageRoute(builder: (BuildContext context) {
        return FilesystemPicker(
          fixedRootDirectory: fixedRootDirectory,
          fixedRootName: fixedRootName,
          fsType: fsType,
          multiSelect: multiSelect,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor == null ? Theme
              .of(context)
              .primaryColor : folderIconColor,
          allowedExtensions: allowedExtensions,
          requestPermission: requestPermission,
        );
      }),
    );
  }

  // ---

  final String? fixedRootName;
  final Directory? fixedRootDirectory;
  final FilesystemType fsType;
  final bool multiSelect;
  final String? pickText;
  final String? cancelText;
  final String? permissionText;
  final String? title;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final RequestPermission? requestPermission;

  FilesystemPicker({
    Key? key,
    this.fixedRootName,
    this.fixedRootDirectory,
    this.fsType = FilesystemType.all,
    this.multiSelect = false,
    this.pickText,
    this.cancelText,
    this.permissionText,
    this.title,
    this.folderIconColor,
    this.allowedExtensions,
    this.requestPermission,
  }) : super(key: key);

  @override
  _FilesystemPickerState createState() => _FilesystemPickerState();
}

class _FilesystemPickerState extends State<FilesystemPicker> {
  bool permissionRequesting = true;
  bool permissionAllowed = false;
  bool useRootSelector = false;
  bool loadingFSE = true;
  bool toggleSelectAll = false;
  bool failedLoadStorageInfo = false;

  final FileSystemListController fileSystemListController = FileSystemListController();
  final StackList<Directory> history = StackList<Directory>();
  final Map<String, FileSystemEntityType> selectedPaths = Map<
      String,
      FileSystemEntityType>();

  final List<StorageInfo> _storageInfo = [];
  Directory? directory;
  String? directoryName;
  final List<_PathItem> pathItems = [];

  Directory? rootDirectory;
  String? rootName = "";

  @override
  void initState() {
    super.initState();
    _requestPermission();
    if (widget.fixedRootDirectory != null) {
      rootDirectory = widget.fixedRootDirectory;
      useRootSelector = false;
      setRootName();
    } else {
      useRootSelector = true;
      _getStoragesInfo();
    }
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

  Future<void> _getStoragesInfo() async {
    try {
      _storageInfo.clear();
      _storageInfo.addAll(await PlatformMethods.getStorageInfo());
      if (rootDirectory == null) {
        rootDirectory = Directory(_storageInfo[0].rootDir);
        setRootName();
        _setDirectory(rootDirectory);
      }
    } catch (err) {
      failedLoadStorageInfo = true;
    }
  }


  void setRootName() {
    if (useRootSelector && rootDirectory != null) {
      rootName = widget.fixedRootName != null ? widget.fixedRootName : _storageInfo
          .where((element) => element.rootDir == rootDirectory!.path)
          .first
          .label;
    } else {
      rootName = widget.fixedRootName != null ? widget.fixedRootName : "Storage";
    }
  }

  Future<void> _setDirectory(Directory? value) async {
    setState(() {
      loadingFSE = true;
    });

    directory = value;

    String dirPath = Path.relative(
        directory!.path,
        from: Path.dirname(rootDirectory!.path));
    final List<String> items = dirPath.split(Platform.pathSeparator);
    pathItems.clear();

    String rootItem = items.first;
    String rootPath = Path.dirname(rootDirectory!.path) +
        Platform.pathSeparator +
        rootItem;
    pathItems.add(_PathItem(path: rootPath, text: rootName ?? rootItem));
    items.removeAt(0);

    String path = rootPath;

    for (var item in items) {
      path += Platform.pathSeparator + item;
      pathItems.add(_PathItem(path: path, text: item));
    }

    directoryName = ((directory!.path == rootDirectory!.path) &&
        (rootName != null))
        ? rootName
        : Path.basename(directory!.path);

    setState(() {
      loadingFSE = false;
    });
  }

  // change directory and put the previous directory into history stack
  Future<void> _changeDirectory(Directory value) async {
    if (directory!.absolute.path != value.absolute.path) {
      toggleSelectAll = false;
      history.push(directory!);
      _setDirectory(value);
      if (widget.multiSelect == false){
        selectedPaths.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackAction,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? directoryName!),
            leading: Builder(
              builder: (ctx) {
                return IconButton(
                  icon: Icon(useRootSelector ? Icons.menu : Icons.close),
                  onPressed: () {
                    if (useRootSelector) {
                      Scaffold.of(ctx).openDrawer();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
            actions: selectedPaths.length > 0 && widget.multiSelect ? [
              IconButton(
                  tooltip: "Select/Unselect All",
                  icon: Icon(Icons.select_all),
                  onPressed: () {
                    fileSystemListController.items.forEach((p) {
                      if (widget.fsType == FilesystemType.all
                          || (widget.fsType == FilesystemType.file &&
                              p.type == FileSystemEntityType.file)
                          || (widget.fsType == FilesystemType.folder &&
                              p.type == FileSystemEntityType.directory)) {
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
                  }
              )
            ] : null,
            bottom: PreferredSize(
              child: Theme(
                data: ThemeData(
                  textTheme: TextTheme(
                    button: TextStyle(
                        color: AppBarTheme
                            .of(context)
                            .textTheme
                            ?.headline6
                            ?.color ??
                            Theme
                                .of(context)
                                .primaryTextTheme
                                .headline6
                                ?.color),
                  ),
                ),
                child: Breadcrumbs<String>(
                  items: (!permissionRequesting && permissionAllowed)
                      ? pathItems
                      .map((path) =>
                      BreadcrumbItem<String>(
                          text: path.text, data: path.path))
                      .toList(growable: false)
                      : [],
                  onSelect: (String? value) {
                    _changeDirectory(Directory(value!));
                  },
                ),
              ),
              preferredSize: const Size.fromHeight(50),
            ),
          ),
          drawerEnableOpenDragGesture: false,
          drawer: useRootSelector ? Drawer(
            child: _storageInfo.length == 0 && failedLoadStorageInfo == false ? Center(child: CircularProgressIndicator(),)
            : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: ListTile(
                        title: Text('Select Storage',
                            style: Theme
                                .of(context)
                                .primaryTextTheme
                                .headline6),
                        leading: Icon(Icons.storage, color: Theme
                            .of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                      ),
                    ),
                  ),
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: () {
                        List<Widget> chs = [];

                        bool internalFirst = true;
                        _storageInfo.forEach((ss) {
                          chs.add(RadioListTile<int>(
                            secondary: selectedPaths.keys.any((ee) =>
                                ee.startsWith(ss.rootDir)) ? Icon(
                                Icons.library_add_check, color: Theme
                                .of(context)
                                .primaryColorDark) : null,
                            title: Text(
                                internalFirst ? "Internal Storage" : Path
                                    .basename(ss.rootDir)),
                            subtitle: Text(
                                "Free Space: " +
                                    ss.availableGB.toString() +
                                    " GB"),
                            value: _storageInfo.indexOf(ss),
                            groupValue: _storageInfo.map((e) => e.rootDir)
                                .toList()
                                .indexOf(rootDirectory!.path),
                            onChanged: (val) {
                              rootDirectory = Directory(_storageInfo[val!].rootDir);
                              setRootName();
                              if (widget.multiSelect == false){
                                selectedPaths.clear();
                              }
                              _setDirectory(rootDirectory);
                              Navigator.pop(context);
                            },
                          ));
                          internalFirst = false;
                        });

                        return chs;
                      }(),
                    )
                ),
                Visibility(
                    visible: selectedPaths.length > 0,
                    child: Material(
                      child: SafeArea(
                        child: ListTile(
                          leading: Icon(
                              Icons.library_add_check, color: Theme
                              .of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                          title: Text("Selected " +
                              (widget.fsType == FilesystemType.all
                                  ? "Items"
                                  : widget.fsType == FilesystemType.file
                                  ? "Files"
                                  : "Directories"),
                              style: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .headline6),
                        ),
                      ),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    )),
                Flexible(
                    fit: FlexFit.tight,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: () {
                        var chs = <Widget>[];
                        selectedPaths.forEach((key, value) {
                          chs.add(ListTile(
                            leading: value == FileSystemEntityType.file
                                ? fileIcon(key, Theme
                                .of(context)
                                .primaryColor)
                                : Icon(
                              Icons.folder,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              size: iconSize,
                            ),
                            title: Text(Path.basename(key)),
                            onTap: () {
                              if (key.startsWith(
                                  rootDirectory!.absolute.path) == false) {
                                rootDirectory = Directory(_storageInfo
                                    .firstWhere((ss) =>
                                    key.startsWith(ss.rootDir))
                                    .rootDir);
                                setRootName();
                              }
                              _changeDirectory(Directory(
                                  key == rootDirectory!.absolute.path
                                      ? key
                                      : Path.dirname(key)));
                              Navigator.pop(context);
                            },
                          ));
                          if (selectedPaths.length > 1) {
                            chs.add(fseHBorder);
                          }
                        });
                        return chs;
                      }(),
                    )
                ),
                Visibility(
                    visible: selectedPaths.length > 1,
                    child: Material(
                      child: ListTile(
                        title: Text("Count:",
                            style: Theme
                                .of(context)
                                .primaryTextTheme
                                .headline6),
                        trailing: Text(selectedPaths.length.toString(),
                            style: Theme
                                .of(context)
                                .primaryTextTheme
                                .headline6),
                      ),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    )),
              ],
            ),
          ) : null,
          body: permissionRequesting || loadingFSE || rootDirectory == null
              ? Center(child: CircularProgressIndicator())
              : (permissionAllowed
              ? FilesystemList(
              controller: fileSystemListController,
              isRoot: (directory!.absolute.path == rootDirectory!.absolute.path),
              rootDirectory: directory!,
              multiSelect: widget.multiSelect,
              fsType: widget.fsType,
              folderIconColor: widget.folderIconColor,
              allowedExtensions: widget.allowedExtensions,
              onChange: _changeDirectory,
              selectedItems: selectedPaths.keys,
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
              }
          )
              : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Text(
                widget.permissionText ??
                    'Access to the storage was not granted.',
                textScaleFactor: 1.2),
          )),
          bottomNavigationBar: Container(
            height: 50,
            child: BottomAppBar(
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: AppBarTheme
                          .of(context)
                          .textTheme
                          ?.headline6
                          ?.color ??
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color,
                    ),
                    icon: Icon(Icons.cancel),
                    label: (widget.cancelText != null)
                        ? Text(widget.cancelText!)
                        : const Text("Cancel"),
                    onPressed: (!permissionRequesting && permissionAllowed)
                        ? () {
                      cancelButtonPressed = true;
                      Navigator.pop(context);
                    }
                        : null,
                  )),
                  VerticalDivider(
                    width: 1,
                    color: Theme
                        .of(context)
                        .accentColor,
                  ),
                  Expanded(child: TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: AppBarTheme
                          .of(context)
                          .textTheme
                          ?.headline6
                          ?.color ??
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color,
                    ),
                    icon: Icon(Icons.check_circle),
                    label: (widget.pickText != null)
                        ? Text(widget.pickText!)
                        : const Text("Select"),
                    onPressed: (!permissionRequesting && permissionAllowed && selectedPaths.length > 0)
                        ? () => Navigator.pop(context, selectedPaths.keys)
                        : null,
                  ))
                ],
              ),
            ),
          )
      ),
    );
  }

  bool cancelButtonPressed = false;

  Future<bool> _handleBackAction() {
    if (cancelButtonPressed == false &&
        directory!.absolute.path != rootDirectory!.absolute.path &&
        history.length > 0) {
      var p = history.pop();
      if (p.absolute.path.startsWith(rootDirectory!.absolute.path) == false) {
        rootDirectory = Directory(_storageInfo
            .firstWhere((ss) => p.absolute.path.startsWith(ss.rootDir))
            .rootDir);
        setRootName();
      }
      _setDirectory(p);
      return Future.value(false);
    }

    // if on root OR history is empty OR cancel btn pressed, close picker
    return Future.value(true);
  }
}
