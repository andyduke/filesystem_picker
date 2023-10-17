import 'dart:async';
import 'dart:io';
import 'package:filesystem_picker/src/actions/action.dart';
import 'package:filesystem_picker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list.dart';
import 'breadcrumbs.dart';
import 'picker_dialog.dart';
import 'options/picker_options.dart';
import 'options/theme/theme.dart';
import 'progress_indicator.dart';
import 'shortcuts/shortcut.dart';
import 'shortcuts/shortcuts_listview.dart';

/// FileSystem file or folder picker dialog/bottom sheet.
///
/// Allows the user to browse the file system and pick a folder or file.
///
/// Be sure to specify either the `rootDirectory` or a non-empty list of `shortcuts`, but not both.
///
/// See also:
///  * [FilesystemPicker.open], which allows you to open a fullscreen FileSystemPicker dialog.
///  * [FilesystemPicker.openDialog], which allows you to open a modal FileSystemPicker dialog above the current contents of the app.
///  * [FilesystemPicker.openBottomSheet], which allows you to open a modal FileSystemPicker bottom sheet above the current contents of the app.
class FilesystemPicker extends StatefulWidget {
  /// Open fullscreen FileSystemPicker dialog.
  ///
  /// Returns null if nothing was selected.
  ///
  /// Be sure to specify either the `rootDirectory` or a non-empty list of `shortcuts`, but not both.
  ///
  /// * [context] specifies the context in which the picker should be opened.
  /// * [rootDirectory] specifies the root of the filesystem view.
  /// * [rootName] specifies the name of the filesystem view root in breadcrumbs, by default "Storage".
  /// * [directory] specifies the current path, which should be opened in the filesystem view by default (if not specified, the `rootDirectory` is used); **attention:** this path must be inside `rootDirectory`.
  /// * [fsType] specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  /// * [pickText] specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  /// * [permissionText] specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  /// * [title] specifies the text of the dialog title.
  /// * [showGoUp] specifies the option to display the go to the previous level of the file system in the filesystem view; the default is true.
  /// * [allowedExtensions] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`.
  /// * [caseSensitiveFileExtensionComparison] specifies the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive; the default is false (case-insensitive).
  /// * [fileTileSelectMode] specifies how to files can be selected (either tapping on the whole tile or only on trailing button). by default depends on [fsType]
  /// * [requestPermission] if specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  /// * [folderIconColor] specifies the folder icon color.
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
  /// * [shortcuts] specifies a list of shortcuts that allow you to specify multiple root drives (for example, in Windows) or favorite paths (as in Linux/MacOS).
  ///
  /// The default parameter values are taken from the [FilesystemPickerDefaultOptions].
  ///
  /// See also:
  /// * [FilesystemPickerDefaultOptions], which provides the ability to set the default picker options.
  /// * [FilesystemPickerTheme], which provides the ability to customize the visual properties of the picker, such as colors, fonts, and icons.
  /// * [FilesystemPickerAutoSystemTheme], which provides an adaptive theme that matches the light or dark theme of the application.
  static Future<String?> open({
    required BuildContext context,
    Directory? rootDirectory,
    String? rootName,
    Directory? directory,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    bool? caseSensitiveFileExtensionComparison,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemListFilter? itemFilter,
    FilesystemPickerThemeBase? theme,
    List<FilesystemPickerContextAction> contextActions = const [],
    List<FilesystemPickerShortcut> shortcuts = const [],
  }) async {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (BuildContext context) {
        return FilesystemPicker(
          rootDirectory: rootDirectory,
          rootName: rootName,
          directory: directory,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          caseSensitiveFileExtensionComparison:
              caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
          shortcuts: shortcuts,
          closeButton: CloseButton(),
        );
      }),
    );
  }

  /// Open a modal FileSystemPicker dialog above the current contents of the app.
  ///
  /// Returns null if nothing was selected.
  ///
  /// Be sure to specify either the `rootDirectory` or a non-empty list of `shortcuts`, but not both.
  ///
  /// * [context] specifies the context in which the picker should be opened.
  /// * [rootDirectory] specifies the root of the filesystem view.
  /// * [rootName] specifies the name of the filesystem view root in breadcrumbs, by default "Storage".
  /// * [directory] specifies the current path, which should be opened in the filesystem view by default (if not specified, the `rootDirectory` is used); **attention:** this path must be inside `rootDirectory`.
  /// * [fsType] specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  /// * [pickText] specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  /// * [permissionText] specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  /// * [title] specifies the text of the dialog title.
  /// * [showGoUp] specifies the option to display the go to the previous level of the file system in the filesystem view; the default is true.
  /// * [allowedExtensions] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`
  /// * [caseSensitiveFileExtensionComparison] specifies the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive; the default is false (case-insensitive).
  /// * [fileTileSelectMode] specifies how to files can be selected (either tapping on the whole tile or only on trailing button), by default depends on [fsType].
  /// * [requestPermission] if specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  /// * [folderIconColor] specifies the folder icon color.
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
  /// * [shortcuts] specifies a list of shortcuts that allow you to specify multiple root drives (for example, in Windows) or favorite paths (as in Linux/MacOS).
  /// * [constraints] specifies the size constraints to apply to the dialog.
  ///
  /// The default parameter values are taken from the [FilesystemPickerDefaultOptions].
  ///
  /// See also:
  /// * [FilesystemPickerDefaultOptions], which provides the ability to set the default picker options.
  /// * [FilesystemPickerTheme], which provides the ability to customize the visual properties of the picker, such as colors, fonts, and icons.
  /// * [FilesystemPickerAutoSystemTheme], which provides an adaptive theme that matches the light or dark theme of the application.
  static Future<String?> openDialog({
    required BuildContext context,
    Directory? rootDirectory,
    String? rootName,
    Directory? directory,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    bool? caseSensitiveFileExtensionComparison,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemListFilter? itemFilter,
    FilesystemPickerThemeBase? theme,
    List<FilesystemPickerContextAction> contextActions = const [],
    List<FilesystemPickerShortcut> shortcuts = const [],
    BoxConstraints? constraints,
  }) async {
    return showDialog<String?>(
      context: context,
      builder: (context) => FilesystemPickerDialog(
        constraints: constraints,
        child: FilesystemPicker(
          rootDirectory: rootDirectory,
          rootName: rootName,
          directory: directory,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          caseSensitiveFileExtensionComparison:
              caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
          shortcuts: shortcuts,
          closeButton: CloseButton(),
        ),
      ),
    );
  }

  /// Open a modal FileSystemPicker bottom sheet above the current contents of the app.
  ///
  /// Returns null if nothing was selected.
  ///
  /// Be sure to specify either the `rootDirectory` or a non-empty list of `shortcuts`, but not both.
  ///
  /// * [context] specifies the context in which the picker should be opened.
  /// * [rootDirectory] specifies the root of the filesystem view.
  /// * [rootName] specifies the name of the filesystem view root in breadcrumbs, by default "Storage".
  /// * [directory] specifies the current path, which should be opened in the filesystem view by default (if not specified, the `rootDirectory` is used); **attention:** this path must be inside `rootDirectory`.
  /// * [fsType] specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  /// * [pickText] specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  /// * [permissionText] specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  /// * [title] specifies the text of the dialog title.
  /// * [showGoUp] specifies the option to display the go to the previous level of the file system in the filesystem view; the default is true.
  /// * [allowedExtensions] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`
  /// * [caseSensitiveFileExtensionComparison] specifies the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive; the default is false (case-insensitive).
  /// * [fileTileSelectMode] specifies how to files can be selected (either tapping on the whole tile or only on trailing button). by default depends on [fsType]
  /// * [requestPermission] if specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  /// * [folderIconColor] specifies the folder icon color.
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
  /// * [shortcuts] specifies a list of shortcuts that allow you to specify multiple root drives (for example, in Windows) or favorite paths (as in Linux/MacOS).
  /// * [constraints] specifies the size constraints to apply to the bottom sheet.
  /// * [barrierColor] specifies the color of the modal barrier that darkens everything below the bottom sheet; if null the default transparent color is used.
  /// * [shape] specifies the shape of the bottom sheet; the default is an 8dp top rounded shape.
  /// * [elevation] specifies the z-coordinate at which to place this material relative to its parent; the default value is 24.
  /// * [initialChildSize] specifies the initial fractional value of the parent container's height to use when displaying the widget; the default value is 0.8.
  /// * [minChildSize] specifies the minimum fractional value of the parent container's height to use when displaying the widget; the default value is 0.6.
  /// * [maxChildSize] specifies the maximum fractional value of the parent container's height to use when displaying the widget; the default value is 0.96.
  ///
  /// The default parameter values are taken from the [FilesystemPickerDefaultOptions].
  ///
  /// See also:
  /// * [FilesystemPickerDefaultOptions], which provides the ability to set the default picker options.
  /// * [FilesystemPickerTheme], which provides the ability to customize the visual properties of the picker, such as colors, fonts, and icons.
  /// * [DraggableScrollableSheet], which allows you to create a bottom sheet that grows and then becomes scrollable once it reaches its maximum size.
  /// * [FilesystemPickerAutoSystemTheme], which provides an adaptive theme that matches the light or dark theme of the application.
  static Future<String?> openBottomSheet({
    required BuildContext context,
    Directory? rootDirectory,
    String? rootName,
    Directory? directory,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    bool? caseSensitiveFileExtensionComparison,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemListFilter? itemFilter,
    FilesystemPickerThemeBase? theme,
    List<FilesystemPickerContextAction> contextActions = const [],
    List<FilesystemPickerShortcut> shortcuts = const [],
    BoxConstraints? constraints,
    Color? barrierColor,
    ShapeBorder? shape,
    double? elevation,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
  }) async {
    final options = FilesystemPickerDefaultOptions.of(context);

    return await showModalBottomSheet(
      context: context,
      backgroundColor: barrierColor ?? options.bottomSheet.barrierColor,
      shape: shape ?? options.bottomSheet.shape,
      elevation: elevation ?? options.bottomSheet.elevation,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      constraints: constraints ?? options.bottomSheet.constraints,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize:
            initialChildSize ?? options.bottomSheet.initialChildSize,
        minChildSize: minChildSize ?? options.bottomSheet.minChildSize,
        maxChildSize: maxChildSize ?? options.bottomSheet.maxChildSize,
        expand: false,
        builder: (context, scrollController) => FilesystemPicker(
          scrollController: scrollController,
          rootDirectory: rootDirectory,
          rootName: rootName,
          directory: directory,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          caseSensitiveFileExtensionComparison:
              caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
          shortcuts: shortcuts,
          closeButton: CloseButton(),
        ),
      ),
    );
  }

  // ---

  /// Specifies the name of the filesystem view root in breadcrumbs.
  final String? rootName;

  /// Specifies the root of the filesystem view.
  final Directory? rootDirectory;

  /// Specifies the current directory of the filesystem view.
  final Directory? directory;

  /// Specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  final FilesystemType? fsType;

  /// Called when a file system item is selected.
  final ValueSelected onSelect;

  /// Specifies the text for the folder selection button (only for [fsType] = FilesystemType.folder).
  final String? pickText;

  /// Specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.".
  final String? permissionText;

  /// Specifies the text of the dialog title.
  final String? title;

  /// Specifies the color of the icon for the folder.
  final Color? folderIconColor;

  /// Specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`
  final List<String>? allowedExtensions;

  /// Specifies the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive; the default is false (case-insensitive).
  final bool? caseSensitiveFileExtensionComparison;

  /// Specifies how to files can be selected (either tapping on the whole tile or only on trailing button). (default depends on [fsType])
  final FileTileSelectMode? fileTileSelectMode;

  /// If specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  final RequestPermission? requestPermission;

  /// Specifies a callback to filter the displayed files in the filesystem view (not set by default); the path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  final FilesystemListFilter? itemFilter;

  /// Specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  final FilesystemPickerThemeBase? theme;

  /// Specifies the option to display the go to the previous level of the file system in the filesystem view; the default is true.
  final bool? showGoUp;

  /// An object that can be used to control the position to which this scroll view is scrolled.
  final ScrollController? scrollController;

  /// A list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
  final List<FilesystemPickerContextAction> contextActions;

  /// A list of shortcuts that allow you to specify multiple root drives (for example, in Windows) or favorite paths (as in Linux/MacOS).
  final List<FilesystemPickerShortcut> shortcuts;

  /// Picker close button.
  final Widget? closeButton;

  /// Controls whether we should try to imply the leading widget if closeButton is null.
  ///
  /// If true and [closeButton] is null, automatically try to deduce what the leading
  /// widget should be. If false and [closeButton] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// Creates a file system item selection widget.
  FilesystemPicker({
    Key? key,
    this.rootName,
    Directory? rootDirectory,
    this.directory,
    this.fsType = FilesystemType.all,
    this.pickText,
    this.permissionText,
    this.title,
    this.folderIconColor,
    this.allowedExtensions,
    this.caseSensitiveFileExtensionComparison,
    required this.onSelect,
    this.fileTileSelectMode,
    this.itemFilter,
    this.requestPermission,
    this.theme,
    this.showGoUp,
    this.scrollController,
    this.contextActions = const [],
    this.shortcuts = const [],
    this.closeButton,
    this.automaticallyImplyLeading = true,
  })  : assert(
            (rootDirectory != null || shortcuts.isNotEmpty) &&
                !(rootDirectory != null && shortcuts.isNotEmpty),
            'You must specify "rootDirectory" or "shortcuts", but not both.'),
        rootDirectory = (rootDirectory != null)
            ? normalizeRootPath(rootDirectory)
            : rootDirectory,
        super(key: key);

  @override
  _FilesystemPickerState createState() => _FilesystemPickerState();
}

enum _FilesystemPickerViewMode {
  shortcuts,
  filesystem,
}

class _FilesystemPickerState extends State<FilesystemPicker> {
  static const double _defaultTopBarIconSize = 24;
  static const double _defaultTopBarHeight = 50;
  static const double _defaultBottomBarHeight = 50;

  @protected
  bool isValidDirectory = true;

  @protected
  bool initialized = false;

  @protected
  bool permissionRequesting = true;

  @protected
  bool permissionAllowed = false;

  @protected
  String? errorMessage;

  @protected
  bool loading = false;

  @protected
  Directory? directory;

  @protected
  String? directoryName;

  @protected
  List<_PathItem> pathItems = [];

  @protected
  late FilesystemPickerOptions options;

  @protected
  FilesystemPickerShortcut? shortcut;

  @protected
  late Directory? rootDirectory = widget.rootDirectory;

  @protected
  _FilesystemPickerViewMode viewMode = _FilesystemPickerViewMode.filesystem;

  String? get rootName => widget.rootName ?? options.rootName;

  FilesystemType get fsType => widget.fsType ?? options.fsType;

  String? get permissionText => widget.permissionText ?? options.permissionText;

  FileTileSelectMode get fileTileSelectMode =>
      widget.fileTileSelectMode ?? options.fileTileSelectMode;

  bool get showGoUp => widget.showGoUp ?? options.showGoUp;

  bool get caseSensitiveFileExtensionComparison =>
      widget.caseSensitiveFileExtensionComparison ??
      options.caseSensitiveFileExtensionComparison;

  FilesystemPickerThemeBase get theme =>
      (widget.theme?.merge(context, options.theme) ?? options.theme);

  Key _fileListKey = UniqueKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      initialized = true;

      options = FilesystemPickerDefaultOptions.of(context);
      _requestPermission();

      // Find rootDirectory or shortcut based on widget.directory
      if (widget.directory != null) {
        if (widget.rootDirectory != null) {
          rootDirectory = _findRootDirectory(widget.directory!);
        } else {
          shortcut = _findRootShortcut(widget.directory!);
          rootDirectory = shortcut?.path;
        }
      } else {
        rootDirectory = widget.rootDirectory;
      }

      // Set viewMode
      if (rootDirectory != null) {
        viewMode = _FilesystemPickerViewMode.filesystem;

        if ((widget.directory != null) &&
            _isDirectoryValid(widget.directory!)) {
          _setDirectory(widget.directory!);
        } else {
          _setDirectory(rootDirectory!);
        }
      } else {
        viewMode = _FilesystemPickerViewMode.shortcuts;
      }
    }
  }

  bool _isDirectorySameOrWithin(Directory rootDirectory, Directory directory) {
    return (rootDirectory.path == directory.path) ||
        Path.isWithin(rootDirectory.path, directory.path);
  }

  Directory? _findRootDirectory(Directory directory) {
    final rootDirectories = (rootDirectory != null)
        ? <Directory>[rootDirectory!]
        : [] /*widget.shortcuts.map<Directory>((s) => s.path)*/;
    for (var rootDirectory in rootDirectories) {
      if (_isDirectorySameOrWithin(rootDirectory, directory)) {
        return rootDirectory;
      }
    }
    return null;
  }

  FilesystemPickerShortcut? _findRootShortcut(Directory directory) {
    for (var shortcut in widget.shortcuts) {
      if (_isDirectorySameOrWithin(shortcut.path, directory)) {
        return shortcut;
      }
    }
    return null;
  }

  bool _isDirectoryValid(Directory directory) {
    if (rootDirectory == null) return false;
    return _isDirectorySameOrWithin(rootDirectory!, directory);
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

  void _setDirectory(Directory value) {
    assert(rootDirectory != null);

    directory = value;

    String currentPath = directory!.path;
    String dirPath = Path.relative(currentPath, from: rootDirectory!.path);
    final List<String> items =
        (dirPath != '.') ? dirPath.split(Platform.pathSeparator) : [];
    pathItems = [];

    if (items.isNotEmpty) {
      String rootItem = items.first;
      String rootPath = rootDirectory!.path;
      pathItems.add(_PathItem(
        path: rootPath,
        text: shortcut?.name ?? rootName ?? rootItem,
      ));

      String path = rootPath;
      for (var item in items) {
        path = Path.join(path, item);
        pathItems.add(_PathItem(path: path, text: item));
      }
    } else {
      pathItems.add(_PathItem(
        path: rootDirectory!.path,
        text: shortcut?.name ?? rootName ?? rootDirectory!.path,
      ));
    }

    directoryName =
        ((directory!.path == rootDirectory!.path) && (rootName != null))
            ? (shortcut?.name ?? rootName)
            : Path.basename(directory!.path);
  }

  void _setShortcut(FilesystemPickerShortcut newShortcut) {
    if (shortcut != newShortcut) {
      viewMode = _FilesystemPickerViewMode.filesystem;
      shortcut = newShortcut;
      rootDirectory = newShortcut.path;

      setState(() {});

      _changeDirectory(shortcut!.path);
    }
  }

  void _changeDirectory(Directory value) {
    if (directory != value) {
      setState(() {
        loading = true;
      });

      _setDirectory(value);

      Future.microtask(() {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      });
    }
  }

  void _reloadList() {
    setState(() {
      _fileListKey = UniqueKey();
    });
  }

  Widget _buildBar(
      BuildContext context, FilesystemPickerActionThemeData theme) {
    if (viewMode != _FilesystemPickerViewMode.filesystem)
      return const SizedBox();
    if (directory == null) return const SizedBox();

    final pickerIconTheme = theme.getCheckIconTheme(context);
    final foregroundColor = (!permissionRequesting && permissionAllowed)
        ? theme.getForegroundColor(context)
        : theme.getDisabledForegroundColor(context);

    return SizedBox(
      height: _defaultBottomBarHeight,
      child: Material(
        color: theme.getBackgroundColor(context),
        shape: theme.getShape(context),
        elevation: theme.getElevation(context) ?? 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: theme.getForegroundColor(context),
              disabledForegroundColor:
                  theme.getDisabledForegroundColor(context),
            ),
            icon: Icon(
              theme.getCheckIcon(context),
              color: foregroundColor,
              size: pickerIconTheme.size,
            ),
            label: (widget.pickText != null)
                ? Text(widget.pickText!,
                    style: theme.getTextStyle(context, foregroundColor))
                : const SizedBox(),
            onPressed:
                (!permissionRequesting && permissionAllowed && isValidDirectory)
                    ? () => widget.onSelect(directory!.absolute.path)
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(
      BuildContext context, FilesystemPickerActionThemeData theme) {
    if (viewMode != _FilesystemPickerViewMode.filesystem)
      return const SizedBox();
    if (directory == null) return const SizedBox();

    final onPressed = (!permissionRequesting && permissionAllowed)
        ? () => widget.onSelect(directory!.absolute.path)
        : null;

    if (widget.pickText != null) {
      return FloatingActionButton.extended(
        icon: Icon(theme.getCheckIcon(context)),
        label: Text(widget.pickText!),
        foregroundColor: theme.getForegroundColor(context),
        backgroundColor: theme.getBackgroundColor(context),
        elevation: theme.getElevation(context),
        onPressed: isValidDirectory ? onPressed : null,
      );
    } else {
      return FloatingActionButton(
        child: Icon(theme.getCheckIcon(context)),
        foregroundColor: theme.getForegroundColor(context),
        backgroundColor: theme.getBackgroundColor(context),
        elevation: theme.getElevation(context),
        onPressed: isValidDirectory ? onPressed : null,
      );
    }
  }

  List<BreadcrumbItem<_BreadcrumbPath>> _buildBreadcrumbs() {
    List<BreadcrumbItem<_BreadcrumbPath>> result = [];

    if (viewMode == _FilesystemPickerViewMode.filesystem) {
      result = (!permissionRequesting && permissionAllowed)
          ? pathItems
              .map((path) => BreadcrumbItem<_BreadcrumbPath>(
                    text: path.text,
                    data: _BreadcrumbPath.filesystem(path.path),
                  ))
              .toList(growable: false)
          : [];
    }

    if (widget.shortcuts.isNotEmpty) {
      result = [
        BreadcrumbItem<_BreadcrumbPath>(
          text: rootName ?? FilesystemPickerOptions.defaultRootName,
          data: _BreadcrumbPath.shortcut(),
        ),
        ...result,
      ];
    }

    return result;
  }

  void _breadcrumbSelect(_BreadcrumbPath? bcrumbPath) {
    if (bcrumbPath == null) return;

    switch (bcrumbPath.type) {
      case _BreadcrumbPathType.shortcuts:
        setState(() {
          viewMode = _FilesystemPickerViewMode.shortcuts;
          shortcut = null;
        });
        break;

      case _BreadcrumbPathType.filesystem:
        if (bcrumbPath.path != null) {
          _changeDirectory(Directory(bcrumbPath.path!));
        }
        break;
    }
  }

  Widget _buildFilesystemListView(FilesystemPickerThemeBase theme) {
    assert(rootDirectory != null);
    assert(directory != null);

    final hasMessage = !permissionAllowed || (errorMessage != null);

    final result = (!initialized || permissionRequesting || loading)
        ? FilesystemProgressIndicator(theme: theme.getFileList(context))
        : (!hasMessage
            ? FilesystemList(
                key: _fileListKey,
                isRoot: (Path.equals(
                    directory!.absolute.path, rootDirectory!.absolute.path)),
                rootDirectory: directory!,
                fsType: fsType,
                folderIconColor: widget.folderIconColor,
                allowedExtensions: widget.allowedExtensions,
                onChange: _changeDirectory,
                onSelect: widget.onSelect,
                fileTileSelectMode: fileTileSelectMode,
                itemFilter: widget.itemFilter,
                theme: theme.getFileList(context),
                showGoUp: showGoUp,
                caseSensitiveFileExtensionComparison:
                    caseSensitiveFileExtensionComparison,
                scrollController: widget.scrollController,
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Text(
                  errorMessage ?? permissionText ?? options.permissionText,
                  textScaleFactor: theme
                      .getFileList(context)
                      .getTextScaleFactor(context, true),
                ),
              ));
    return result;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (viewMode != _FilesystemPickerViewMode.filesystem) return null;
    if (directory == null) return null;
    if (widget.contextActions.isEmpty) return null;

    final hasMessage = !permissionAllowed || (errorMessage != null);

    final contextActionsTheme = theme.getContextActions(context);
    final buttonTheme = contextActionsTheme.getButtonTheme(context);
    final menuTheme = contextActionsTheme.getMenuTheme(context);

    if (widget.contextActions.length == 1) {
      return [
        IconTheme.merge(
          data: buttonTheme.getIconTheme(context),
          child: IconButton(
            icon: widget.contextActions.first.icon,
            tooltip: widget.contextActions.first.text,
            onPressed: !hasMessage
                ? () => _callAction(
                    widget.contextActions.first, context, directory!)
                : null,
          ),
        ),
      ];
    } else {
      return [
        Theme(
          data: Theme.of(context).copyWith(
            highlightColor: menuTheme.getHighlightBackgroundColor(
                context), // Selected item background
            popupMenuTheme: PopupMenuThemeData(
              color: menuTheme.getBackgroundColor(context), // Menu background
              textStyle: menuTheme.getTextStyle(context),
              shape: menuTheme.getShape(context),
              elevation: menuTheme.getElevation(context),
            ),
            iconTheme: buttonTheme.getIconTheme(context),
          ),
          child: PopupMenuButton<FilesystemPickerContextAction>(
            offset: Offset(0, 48),
            onSelected: (action) => _callAction(action, context, directory!),
            enabled: !hasMessage,
            itemBuilder: (context) => widget.contextActions
                .map((e) => PopupMenuItem<FilesystemPickerContextAction>(
                      value: e,
                      child: Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              iconTheme: menuTheme.getIconTheme(context),
                            ),
                            child: e.icon,
                          ),
                          const SizedBox(width: 16),
                          Text(e.text),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ];
    }
  }

  Future<void> _callAction(FilesystemPickerContextAction action,
      BuildContext context, Directory path) async {
    final result = await action.call(context, path);
    if (result) {
      _reloadList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme;
    final topBarTheme = effectiveTheme.getTopBar(context);
    final foregroundColor = topBarTheme.getForegroundColor(context);
    final backgroundColor = topBarTheme.getBackgroundColor(context);
    final elevation = topBarTheme.getElevation(context);
    final shadowColor = topBarTheme.getShadowColor(context);
    final shape = topBarTheme.getShape(context);
    final iconTheme = topBarTheme.getIconTheme(context);
    final titleTextStyle = topBarTheme.getTitleTextStyle(context);
    final systemOverlayStyle = topBarTheme.getSystemOverlayStyle(context);
    final breadcrumbsTheme = topBarTheme.getBreadcrumbsThemeData(context);
    final pickerActionTheme = effectiveTheme.getPickerAction(context);

    final PreferredSizeWidget appBar = AppBar(
      // Theme
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      iconTheme: iconTheme,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      scrolledUnderElevation: topBarTheme.getScrolledUnderElevation(context),

      // Props
      title: Text(widget.title ?? directoryName ?? '',
          style: titleTextStyle?.copyWith(color: foregroundColor)),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: (widget.closeButton != null)
          ? IconTheme.merge(
              data: IconThemeData(
                size: iconTheme?.size ?? _defaultTopBarIconSize,
              ),
              child: widget.closeButton!,
            )
          : null,
      actions: _buildActions(context),
      bottom: PreferredSize(
        child: Breadcrumbs<_BreadcrumbPath>(
          theme: breadcrumbsTheme,
          textColor: foregroundColor,
          items: _buildBreadcrumbs(),
          onSelect: _breadcrumbSelect,
        ),
        preferredSize: const Size.fromHeight(_defaultTopBarHeight),
      ),
    );

    Widget body;

    switch (viewMode) {
      case _FilesystemPickerViewMode.shortcuts:
        body = FilesystemShortcutsListView(
          shortcuts: widget.shortcuts,
          theme: theme.getFileList(context),
          fsType: fsType,
          onChange: _setShortcut,
          onSelect: (value) => widget.onSelect(value.path.toString()),
        );
        break;

      case _FilesystemPickerViewMode.filesystem:
        body = _buildFilesystemListView(effectiveTheme);
        break;
    }

    return Scaffold(
      backgroundColor: effectiveTheme.getBackgroundColor(context),
      appBar: appBar,

      // File list
      body: SizedBox.expand(child: body),

      // Picker Action
      floatingActionButton:
          (pickerActionTheme.isFABMode && (fsType == FilesystemType.folder))
              ? _buildFAB(context, pickerActionTheme)
              : null,
      floatingActionButtonLocation:
          pickerActionTheme.getFloatingButtonLocation(context),
      bottomNavigationBar:
          (pickerActionTheme.isBarMode && (fsType == FilesystemType.folder))
              ? _buildBar(context, pickerActionTheme)
              : null,
    );
  }
}

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

enum _BreadcrumbPathType {
  shortcuts,
  filesystem,
}

class _BreadcrumbPath {
  final _BreadcrumbPathType type;
  final String? path;

  _BreadcrumbPath.shortcut()
      : type = _BreadcrumbPathType.shortcuts,
        path = null;

  _BreadcrumbPath.filesystem(String this.path)
      : type = _BreadcrumbPathType.filesystem;

  @override
  String toString() {
    return '_BreadcrumbPath($type${(type == _BreadcrumbPathType.filesystem) ? ': $path' : ''})';
  }
}
