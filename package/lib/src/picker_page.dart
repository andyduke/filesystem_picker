import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'common.dart';
import 'filesystem_list.dart';
import 'package:path/path.dart' as Path;
import 'breadcrumbs.dart';
import 'options/picker_dialog.dart';
import 'options/picker_options.dart';
import 'options/theme/theme.dart';
import 'options/theme/theme_base.dart';
import 'progress_indicator.dart';

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
  /// * [theme] TODO:
  static Future<String?> open({
    required BuildContext context,
    required Directory rootDirectory,
    String? rootName,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemPickerThemeBase? theme,
  }) async {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (BuildContext context) {
        return FilesystemPicker(
          rootDirectory: rootDirectory,
          rootName: rootName,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          theme: theme,
        );
      }),
    );
  }

  // TODO: documentation
  static Future<String?> openDialog({
    required BuildContext context,
    required Directory rootDirectory,
    String? rootName,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemPickerThemeBase? theme,
    BoxConstraints? constraints,
  }) async {
    return showDialog<String?>(
      context: context,
      builder: (context) => FilesystemPickerDialog(
        constraints: constraints,
        child: FilesystemPicker(
          rootDirectory: rootDirectory,
          rootName: rootName,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          theme: theme,
        ),
      ),
    );
  }

  // TODO: documentation
  static Future<String?> openBottomSheet({
    required BuildContext context,
    required Directory rootDirectory,
    String? rootName,
    FilesystemType? fsType,
    String? pickText,
    String? permissionText,
    String? title,
    Color? folderIconColor,
    bool? showGoUp,
    List<String>? allowedExtensions,
    FileTileSelectMode? fileTileSelectMode,
    RequestPermission? requestPermission,
    FilesystemPickerThemeBase? theme,
    BoxConstraints? constraints,

    // TODO: BottomSheet options
  }) async {
    // TODO: refactor to FilesystemPickerBottomSheet

    return await showModalBottomSheet(
      context: context,
      backgroundColor: Color(0x00000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      elevation: 24,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: 300,
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) => FilesystemPicker(
          scrollController: scrollController,
          rootDirectory: rootDirectory,
          rootName: rootName,
          fsType: fsType,
          pickText: pickText,
          permissionText: permissionText,
          title: title,
          folderIconColor: folderIconColor,
          allowedExtensions: allowedExtensions,
          onSelect: (String value) {
            Navigator.of(context).pop<String>(value);
          },
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          requestPermission: requestPermission,
          theme: theme,
        ),
      ),
    );
  }

  // ---

  /// Specifies the name of the filesystem view root in breadcrumbs.
  final String? rootName;

  /// Specifies the root of the filesystem view.
  final Directory rootDirectory;

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

  /// Specifies how to files can be selected (either tapping on the whole tile or only on trailing button). (default depends on [fsType])
  final FileTileSelectMode? fileTileSelectMode;

  /// If specified will be called on initialization to request storage permission. callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler).
  final RequestPermission? requestPermission;

  final FilesystemPickerThemeBase? theme;

  final bool? showGoUp;

  final ScrollController? scrollController;

  /// Creates a file system item selection widget.
  FilesystemPicker({
    Key? key,
    this.rootName,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.pickText,
    this.permissionText,
    this.title,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.requestPermission,
    this.theme,
    this.showGoUp,
    this.scrollController,
  }) : super(key: key);

  @override
  _FilesystemPickerState createState() => _FilesystemPickerState();
}

class _FilesystemPickerState extends State<FilesystemPicker> {
  static const double _defaultTopBarIconSize = 24;
  static const double _defaultTopBarHeight = 50;
  static const double _defaultBottomBarHeight = 50;

  bool initialized = false;

  bool permissionRequesting = true;
  bool permissionAllowed = false;

  late Directory directory;
  String? directoryName;
  late List<_PathItem> pathItems;

  late FilesystemPickerOptions options;

  String? get rootName => widget.rootName ?? options.rootName;
  FilesystemType get fsType => widget.fsType ?? options.fsType;
  String? get permissionText => widget.permissionText ?? options.permissionText;
  FileTileSelectMode get fileTileSelectMode => widget.fileTileSelectMode ?? options.fileTileSelectMode;
  bool get showGoUp => widget.showGoUp ?? options.showGoUp;
  FilesystemPickerThemeBase get theme => (widget.theme?.merge(context, options.theme) ?? options.theme);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      initialized = true;

      options = FilesystemPickerDefaultOptions.of(context);

      _requestPermission();
      _setDirectory(widget.rootDirectory);
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
        _setDirectory(value);
      });
    }
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
            onPressed:
                (!permissionRequesting && permissionAllowed) ? () => widget.onSelect(directory.absolute.path) : null,
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
        onPressed: onPressed,
      );
    } else {
      return FloatingActionButton(
        child: Icon(theme.getCheckIcon(context)),
        foregroundColor: theme.getForegroundColor(context),
        backgroundColor: theme.getBackgroundColor(context),
        elevation: theme.getElevation(context),
        onPressed: onPressed,
      );
    }
  }

  List<BreadcrumbItem<String>> _getBreadcrumbs() {
    return (!permissionRequesting && permissionAllowed)
        ? pathItems.map((path) => BreadcrumbItem<String>(text: path.text, data: path.path)).toList(growable: false)
        : [];
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

    final Widget body = (!initialized || permissionRequesting)
        ? FilesystemProgressIndicator(theme: effectiveTheme.getFileList(context))
        : (permissionAllowed
            ? FilesystemList(
                isRoot: (directory.absolute.path == widget.rootDirectory.absolute.path),
                rootDirectory: directory,
                fsType: fsType,
                folderIconColor: widget.folderIconColor,
                allowedExtensions: widget.allowedExtensions,
                onChange: _changeDirectory,
                onSelect: widget.onSelect,
                fileTileSelectMode: fileTileSelectMode,
                theme: effectiveTheme.getFileList(context),
                showGoUp: showGoUp,
                scrollController: widget.scrollController,
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Text(permissionText ?? options.permissionText, textScaleFactor: 1.2),
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
