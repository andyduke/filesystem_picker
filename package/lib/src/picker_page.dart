import 'dart:async';
import 'dart:io';
import 'package:filesystem_picker/src/actions/action.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list.dart';
import 'breadcrumbs.dart';
import 'picker_dialog.dart';
import 'options/picker_options.dart';
import 'options/theme/theme.dart';
import 'progress_indicator.dart';

/// FileSystem file or folder picker dialog
///
/// Allows the user to browse the file system and pick a folder or file.
///
/// See also:
///  * [FilesystemPicker.open], which allows you to open a fullscreen FileSystemPicker dialog.
///  * [FilesystemPicker.openDialog], which allows you to open a modal FileSystemPicker dialog above the current contents of the app.
///  * [FilesystemPicker.openBottomSheet], which allows you to open a modal FileSystemPicker bottom sheet above the current contents of the app.
class FilesystemPicker extends StatefulWidget {
  /// Open fullscreen FileSystemPicker dialog
  ///
  /// Returns null if nothing was selected.
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
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
  ///
  /// The default parameter values are taken from the [FilesystemPickerDefaultOptions].
  ///
  /// See also:
  /// * [FilesystemPickerDefaultOptions], which provides the ability to set the default picker options.
  /// * [FilesystemPickerTheme], which provides the ability to customize the visual properties of the picker, such as colors, fonts, and icons.
  /// * [FilesystemPickerAutoSystemTheme], which provides an adaptive theme that matches the light or dark theme of the application.
  static Future<String?> open({
    required BuildContext context,
    required Directory rootDirectory,
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
          caseSensitiveFileExtensionComparison: caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
        );
      }),
    );
  }

  /// Open a modal FileSystemPicker dialog above the current contents of the app
  ///
  /// Returns null if nothing was selected.
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
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
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
    required Directory rootDirectory,
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
          caseSensitiveFileExtensionComparison: caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
        ),
      ),
    );
  }

  /// Open a modal FileSystemPicker bottom sheet above the current contents of the app
  ///
  /// Returns null if nothing was selected.
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
  /// * [itemFilter] specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not.
  /// * [theme] specifies a picker theme in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree.
  /// * [contextActions] specifies a list of actions, such as "Create Folder", which are placed in the upper right corner of the picker.
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
    required Directory rootDirectory,
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
        initialChildSize: initialChildSize ?? options.bottomSheet.initialChildSize,
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
          caseSensitiveFileExtensionComparison: caseSensitiveFileExtensionComparison,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          itemFilter: itemFilter,
          theme: theme,
          contextActions: contextActions,
        ),
      ),
    );
  }

  // ---

  /// Specifies the name of the filesystem view root in breadcrumbs.
  final String? rootName;

  /// Specifies the root of the filesystem view.
  final Directory rootDirectory;

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

  /// Creates a file system item selection widget.
  FilesystemPicker({
    Key? key,
    this.rootName,
    required this.rootDirectory,
    this.directory,
    this.fsType = FilesystemType.all,
    this.pickText,
    this.permissionText,
    this.title,
    this.folderIconColor,
    this.allowedExtensions,
    this.caseSensitiveFileExtensionComparison,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.itemFilter,
    this.requestPermission,
    this.theme,
    this.showGoUp,
    this.scrollController,
    this.contextActions = const [],
  }) : super(key: key);

  @override
  _FilesystemPickerState createState() => _FilesystemPickerState();
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
  late Directory directory;

  @protected
  String? directoryName;

  @protected
  late List<_PathItem> pathItems;

  @protected
  late FilesystemPickerOptions options;

  String? get rootName => widget.rootName ?? options.rootName;

  FilesystemType get fsType => widget.fsType ?? options.fsType;

  String? get permissionText => widget.permissionText ?? options.permissionText;

  FileTileSelectMode get fileTileSelectMode => widget.fileTileSelectMode ?? options.fileTileSelectMode;

  bool get showGoUp => widget.showGoUp ?? options.showGoUp;

  bool get caseSensitiveFileExtensionComparison =>
      widget.caseSensitiveFileExtensionComparison ?? options.caseSensitiveFileExtensionComparison;

  FilesystemPickerThemeBase get theme => (widget.theme?.merge(context, options.theme) ?? options.theme);

  Key _fileListKey = UniqueKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      initialized = true;

      options = FilesystemPickerDefaultOptions.of(context);
      _requestPermission();
      _setDirectory(_validInitialDirectory);
    }
  }

  Directory get _validInitialDirectory {
    if (widget.directory != null) {
      if (!Path.isWithin(widget.rootDirectory.path, widget.directory!.path)) {
        setState(() {
          errorMessage =
              'Invalid directory "${widget.directory!.path}": not contained within the root directory "${widget.rootDirectory.path}".';
          isValidDirectory = false;
        });

        return widget.rootDirectory;
      }
    }

    return widget.directory ?? widget.rootDirectory;
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
    directory = value;

    String dirPath = Path.relative(directory.path, from: Path.dirname(widget.rootDirectory.path));
    final List<String> items = dirPath.split(Platform.pathSeparator);
    pathItems = [];

    String rootItem = items.first;
    String rootPath = Path.dirname(widget.rootDirectory.path) + Platform.pathSeparator + rootItem;
    pathItems.add(_PathItem(path: rootPath, text: rootName ?? rootItem));
    items.removeAt(0);

    String path = rootPath;

    for (var item in items) {
      path += Platform.pathSeparator + item;
      pathItems.add(_PathItem(path: path, text: item));
    }

    directoryName = ((directory.path == widget.rootDirectory.path) && (rootName != null))
        ? rootName
        : Path.basename(directory.path);
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

  Widget _buildBar(BuildContext context, FilesystemPickerActionThemeData theme) {
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
              primary: theme.getForegroundColor(context),
              onSurface: theme.getDisabledForegroundColor(context),
            ),
            icon: Icon(
              theme.getCheckIcon(context),
              // color: pickerIconTheme.color,
              color: foregroundColor,
              size: pickerIconTheme.size,
            ),
            label: (widget.pickText != null)
                ? Text(widget.pickText!, style: theme.getTextStyle(context, foregroundColor))
                : const SizedBox(),
            onPressed: (!permissionRequesting && permissionAllowed && isValidDirectory)
                ? () => widget.onSelect(directory.absolute.path)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context, FilesystemPickerActionThemeData theme) {
    final onPressed =
        (!permissionRequesting && permissionAllowed) ? () => widget.onSelect(directory.absolute.path) : null;

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

  List<BreadcrumbItem<String>> _getBreadcrumbs() {
    return (!permissionRequesting && permissionAllowed)
        ? pathItems.map((path) => BreadcrumbItem<String>(text: path.text, data: path.path)).toList(growable: false)
        : [];
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (widget.contextActions.isEmpty) return null;

    final hasMessage = !permissionAllowed || (errorMessage != null);

    if (widget.contextActions.length == 1) {
      return [
        IconButton(
          icon: widget.contextActions.first.icon,
          tooltip: widget.contextActions.first.text,
          onPressed: !hasMessage ? () => _callAction(widget.contextActions.first.action, context, directory) : null,
        ),
      ];
    } else {
      return [
        PopupMenuButton<FilesystemPickerContextAction>(
          offset: Offset(0, 48),
          onSelected: (action) => _callAction(action.action, context, directory),
          enabled: !hasMessage,
          itemBuilder: (context) => widget.contextActions
              .map((e) => PopupMenuItem<FilesystemPickerContextAction>(
                    value: e,
                    child: Row(
                      children: [
                        e.icon,
                        const SizedBox(width: 16),
                        Text(e.text),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ];
    }
  }

  Future<void> _callAction(FilesystemPickerContextActionCallback action, BuildContext context, Directory path) async {
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

      // Props
      title: Text(widget.title ?? directoryName ?? '', style: titleTextStyle?.copyWith(color: foregroundColor)),
      leading: IconButton(
        iconSize: iconTheme?.size ?? _defaultTopBarIconSize,
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: _buildActions(context),
      bottom: PreferredSize(
        child: Breadcrumbs<String>(
          theme: breadcrumbsTheme,
          textColor: foregroundColor,
          items: _getBreadcrumbs(),
          onSelect: (String? value) {
            if (value != null) _changeDirectory(Directory(value));
          },
        ),
        preferredSize: const Size.fromHeight(_defaultTopBarHeight),
      ),
    );

    final hasMessage = !permissionAllowed || (errorMessage != null);

    final Widget body = (!initialized || permissionRequesting || loading)
        ? FilesystemProgressIndicator(theme: effectiveTheme.getFileList(context))
        : (!hasMessage
            ? FilesystemList(
                key: _fileListKey,
                isRoot: (Path.equals(directory.absolute.path, widget.rootDirectory.absolute.path)),
                rootDirectory: directory,
                fsType: fsType,
                folderIconColor: widget.folderIconColor,
                allowedExtensions: widget.allowedExtensions,
                onChange: _changeDirectory,
                onSelect: widget.onSelect,
                fileTileSelectMode: fileTileSelectMode,
                itemFilter: widget.itemFilter,
                theme: effectiveTheme.getFileList(context),
                showGoUp: showGoUp,
                caseSensitiveFileExtensionComparison: caseSensitiveFileExtensionComparison,
                scrollController: widget.scrollController,
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Text(errorMessage ?? permissionText ?? options.permissionText,
                    textScaleFactor: effectiveTheme.getFileList(context).getTextScaleFactor(context, true)),
              ));

    return Scaffold(
      backgroundColor: effectiveTheme.getBackgroundColor(context),
      appBar: appBar,

      // File list
      body: SizedBox.expand(child: body),

      // Picker Action
      floatingActionButton: (pickerActionTheme.isFABMode && (fsType == FilesystemType.folder))
          ? _buildFAB(context, pickerActionTheme)
          : null,
      floatingActionButtonLocation: pickerActionTheme.getFloatingButtonLocation(context),
      bottomNavigationBar: (pickerActionTheme.isBarMode && (fsType == FilesystemType.folder))
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
