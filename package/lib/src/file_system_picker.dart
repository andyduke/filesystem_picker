import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart' as path;

import 'utils/models/path_item.dart';
import 'utils/models/stack_list.dart';
import 'constants/typedefs/typedefs.dart';
import 'constants/enums/file_system_type.dart';
import 'platform/platform.dart';
import 'utils/helpers/file_icon_helper.dart';
import 'utils/models/breadcrumb_item.dart';
import 'utils/models/file_system_mini_item.dart';
import 'utils/models/storage_info.dart';
import 'widgets/breadcrumbs.dart';
import 'widgets/file_system_list.dart';
import 'widgets/filename_text.dart';

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
  /// * [fixedRootDirectory] specifies the root of the filesystem view.
  /// * [fixedRootName] specifies the name of the filesystem view root in breadcrumbs, by default "Storage".
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
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FilesystemPicker(
            fixedRootDirectory: fixedRootDirectory,
            fixedRootName: fixedRootName,
            fsType: fsType,
            multiSelect: multiSelect,
            pickText: pickText,
            cancelText: cancelText,
            permissionText: permissionText,
            title: title,
            folderIconColor: folderIconColor ?? Theme.of(context).primaryColor,
            allowedExtensions: allowedExtensions,
            requestPermission: requestPermission,
            themeData: themeData,
            textDirection: textDirection,
          );
        },
      ),
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
  final ThemeData? themeData;
  final TextDirection? textDirection;

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
    this.themeData,
    this.textDirection,
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

  final List<FileSystemMiniItem> items = [];
  final StackList<Directory> history = StackList<Directory>();
  final Map<String, FileSystemEntityType> selectedPaths =
      <String, FileSystemEntityType>{};

  final List<StorageInfo> _storageInfo = [];
  Directory? directory;
  String? directoryName;
  final List<PathItem> pathItems = [];

  Directory? rootDirectory;
  String? rootName = '';

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

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _requestPermission();
      if (widget.fixedRootDirectory != null) {
        rootDirectory = widget.fixedRootDirectory;
        useRootSelector = false;
        setRootName();
      } else {
        useRootSelector = true;
        _getStorageInfo();
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

  Future<void> _getStorageInfo() async {
    try {
      _storageInfo.clear();
      _storageInfo.addAll(await PlatformMethods.getStorageInfo());
      if (rootDirectory == null) {
        rootDirectory = Directory(_storageInfo[0].rootDir);
        setRootName();
      }
    } catch (err) {
      failedLoadStorageInfo = true;
    }
  }

  void setRootName() {
    if (useRootSelector && rootDirectory != null) {
      rootName = widget.fixedRootName ??
          _storageInfo
              .where((element) => element.rootDir == rootDirectory!.path)
              .first
              .label;
    } else {
      rootName = widget.fixedRootName ?? 'Storage';
    }

    _setDirectory(rootDirectory);
  }

  void _setDirectory(Directory? value) {
    setState(() {
      loadingFSE = true;
    });

    directory = value;

    var directoryPath =
        path.relative(directory!.path, from: path.dirname(rootDirectory!.path));
    final items = directoryPath.split(Platform.pathSeparator);
    pathItems.clear();

    var rootItem = items.first;
    var rootPath =
        path.dirname(rootDirectory!.path) + Platform.pathSeparator + rootItem;
    pathItems.add(PathItem(path: rootPath, text: rootName ?? rootItem));
    items.removeAt(0);

    var tmpPath = rootPath;

    for (var item in items) {
      tmpPath += Platform.pathSeparator + item;
      pathItems.add(PathItem(path: tmpPath, text: item));
    }

    directoryName =
        ((directory!.path == rootDirectory!.path) && (rootName != null))
            ? rootName
            : path.basename(directory!.path);

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
      child: Builder(builder: (_) {
        return Theme(
          data: widget.themeData ?? Theme.of(context),
          child: Directionality(
            textDirection: widget.textDirection ?? Directionality.of(context),
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
                actions: selectedPaths.isNotEmpty && widget.multiSelect
                    ? [
                        IconButton(
                            tooltip: 'Select/Deselect All',
                            icon: Icon(Icons.select_all),
                            onPressed: () {
                              items.forEach((p) {
                                if (widget.fsType == FilesystemType.all ||
                                    (widget.fsType == FilesystemType.file &&
                                        p.type == FileSystemEntityType.file) ||
                                    (widget.fsType == FilesystemType.folder &&
                                        p.type ==
                                            FileSystemEntityType.directory)) {
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
                bottom: _buildBreadCrumb(),
              ),
              drawerEnableOpenDragGesture: false,
              drawer: useRootSelector ? _buildDrawer() : null,
              body: _buildBody(),
              bottomNavigationBar: _buildButtonNavigationBar(context),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody() {
    if (permissionRequesting || loadingFSE || rootDirectory == null) {
      return Center(child: CircularProgressIndicator());
    }
    return permissionAllowed
        ? FilesystemList(
            items: items,
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
            })
        : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Text(
                widget.permissionText ??
                    'Access to the storage was not granted.',
                textScaleFactor: 1.2),
          );
  }

  Widget _buildButtonNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Container(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  primary:
                      AppBarTheme.of(context).textTheme?.headline6?.color ??
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
              ),
            ),
            VerticalDivider(
              width: 1,
              color: Theme.of(context).accentColor,
            ),
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  primary:
                      AppBarTheme.of(context).textTheme?.headline6?.color ??
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBreadCrumb() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Theme(
        data: ThemeData(
          textTheme: TextTheme(
            button: TextStyle(
              color: AppBarTheme.of(context).textTheme?.headline6?.color ??
                  Theme.of(context).primaryTextTheme.headline6?.color,
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

  Widget _buildDrawer() {
    return Drawer(
      child: _storageInfo.isEmpty && failedLoadStorageInfo == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Material(
                  color: Theme.of(context).primaryColor,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: ListTile(
                        title: Text(
                          'Select Storage',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                        leading: Icon(
                          Icons.storage,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _storageInfo.length,
                    itemBuilder: (_, index) {
                      var info = _storageInfo.elementAt(index);
                      return RadioListTile<int>(
                        secondary: selectedPaths.keys.any(
                                (entity) => entity.startsWith(info.rootDir))
                            ? Icon(
                                Icons.library_add_check,
                                color: Theme.of(context).primaryColorDark,
                              )
                            : null,
                        title: Text(
                          (index == 0)
                              ? 'Internal Storage'
                              : path.basename(info.rootDir),
                        ),
                        subtitle: Text(
                          'Free Space: ' + info.availableGB.toString() + ' GB',
                        ),
                        value: _storageInfo.indexOf(info),
                        groupValue: _storageInfo
                            .map((e) => e.rootDir)
                            .toList()
                            .indexOf(rootDirectory!.path),
                        onChanged: (val) {
                          rootDirectory = Directory(_storageInfo[val!].rootDir);
                          setRootName();
                          if (widget.multiSelect == false) {
                            selectedPaths.clear();
                          }
                          _setDirectory(rootDirectory);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: selectedPaths.isNotEmpty,
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      leading: Icon(
                        Icons.library_add_check,
                        color:
                            Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
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
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: selectedPaths.length,
                    separatorBuilder: (_, index) {
                      return Divider(color: Colors.grey, height: 1);
                    },
                    itemBuilder: (_, index) {
                      var key = selectedPaths.keys.elementAt(index);
                      var value = selectedPaths.values.elementAt(index);
                      return ListTile(
                        leading: value == FileSystemEntityType.file
                            ? FileIconHelper.getIcon(
                                key, Theme.of(context).primaryColor)
                            : Icon(
                                Icons.folder,
                                color: Theme.of(context).primaryColor,
                                size: FileIconHelper.iconSize,
                              ),
                        title: FilenameText(
                          key,
                          isDirectory: value == FileSystemEntityType.directory,
                        ),
                        onTap: () {
                          if (key.startsWith(rootDirectory!.absolute.path) ==
                              false) {
                            rootDirectory = Directory(_storageInfo
                                .firstWhere((ss) => key.startsWith(ss.rootDir))
                                .rootDir);
                            setRootName();
                          }
                          _changeDirectory(Directory(
                              key == rootDirectory!.absolute.path
                                  ? key
                                  : path.dirname(key)));
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
