import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list_tile.dart';
import 'options/theme/_filelist_theme.dart';
import 'progress_indicator.dart';

/// The signature of the folder and file list widget filter.
typedef FilesystemListFilter = bool Function(
    FileSystemEntity fsEntity, String path, String name);

/// A widget that displays a list of folders and files of the file system.
class FilesystemList extends StatefulWidget {
  /// Is the displayed directory the root directory?
  /// If yes, then the item `..` will not be displayed
  /// at the beginning of the list to go to the parent directory.
  final bool isRoot;

  /// The displayed directory.
  final Directory rootDirectory;

  /// The type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`.
  final FilesystemType fsType;

  /// The color of the folder icon in the list.
  final Color? folderIconColor;

  /// A list of file extensions, only files with the specified extensions will be
  /// displayed in the list. If the list is not specified or an empty list is specified,
  /// all files will be displayed. Does not affect the display of subfolders.
  final List<String>? allowedExtensions;

  /// Called when the user has touched a subfolder list item.
  final ValueChanged<Directory> onChange;

  /// Called when a file system item is selected.
  final ValueSelected onSelect;

  /// Specifies how to files can be selected (either tapping on the whole tile or only on trailing button).
  final FileTileSelectMode fileTileSelectMode;

  /// Specifies a list theme in which colors, fonts, icons, etc. can be customized.
  final FilesystemPickerFileListThemeData? theme;

  /// Specifies the option to display the go to the previous level of the file system in
  /// the filesystem view, the default is true.
  final bool showGoUp;

  /// Specifies the mode of comparing extensions with the `allowedExtensions` list,
  /// case-sensitive or case-insensitive, by default it is insensitive.
  final bool caseSensitiveFileExtensionComparison;

  /// An object that can be used to control the position to which this list is scrolled.
  final ScrollController? scrollController;

  /// Specifies a callback to filter the displayed folders and files in the list;
  /// the filesystem entity, path to the file/directory and its name are passed to the callback,
  /// the callback should return a boolean value - to display the file/directory or not.
  final FilesystemListFilter? itemFilter;

  /// Creates a list widget that displays a list of folders and files of the file system.
  FilesystemList({
    Key? key,
    this.isRoot = false,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onChange,
    required this.onSelect,
    required this.fileTileSelectMode,
    this.theme,
    this.showGoUp = true,
    this.caseSensitiveFileExtensionComparison = false,
    this.scrollController,
    this.itemFilter,
  }) : super(key: key);

  @override
  State<FilesystemList> createState() => _FilesystemListState();
}

class _FilesystemListState extends State<FilesystemList> {
  late Directory _rootDirectory;
  Future<List<FileSystemEntity>>? _dirContents;

  @override
  void initState() {
    super.initState();

    _rootDirectory = widget.rootDirectory;
    _loadDirContents();
  }

  @override
  void didUpdateWidget(covariant FilesystemList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!Path.equals(oldWidget.rootDirectory.absolute.path,
        widget.rootDirectory.absolute.path)) {
      _rootDirectory = widget.rootDirectory;
      _loadDirContents();
    }
  }

  void _loadDirContents() async {
    if (!await _rootDirectory.exists()) {
      setState(() {
        _dirContents =
            Future.error('The "${_rootDirectory.path} path does not exist.');
      });
      return;
    }

    final List<String>? allowedExtensions =
        widget.caseSensitiveFileExtensionComparison
            ? widget.allowedExtensions
            : widget.allowedExtensions
                ?.map((e) => e.toLowerCase())
                .toList(growable: false);

    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    var lister = _rootDirectory.list(recursive: false);
    lister.listen(
      (file) {
        if (widget.itemFilter != null) {
          final localPath = Path.relative(file.path, from: _rootDirectory.path);
          if (!widget.itemFilter!.call(file, _rootDirectory.path, localPath))
            return;
        }

        if ((widget.fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) &&
              (allowedExtensions != null) &&
              (allowedExtensions.length > 0)) {
            String ext = Path.extension(file.path);
            if (!widget.caseSensitiveFileExtensionComparison) {
              ext = ext.toLowerCase();
            }
            if (!allowedExtensions.contains(ext)) return;
          }
          files.add(file);
        }
      },
      onDone: () {
        files.sort((a, b) {
          if (a.runtimeType == b.runtimeType) {
            return a.path.compareTo(b.path);
          } else {
            if (a is Directory) {
              return -1;
            } else {
              return 1;
            }
          }
        });
        completer.complete(files);
      },
    );

    setState(() {
      _dirContents = completer.future;
    });
  }

  InkWell _upNavigation(
      BuildContext context, FilesystemPickerFileListThemeData theme) {
    final iconTheme = theme.getUpIconTheme(context);

    return InkWell(
      child: ListTile(
        leading: Icon(
          theme.getUpIcon(context),
          size: iconTheme.size,
          color: iconTheme.color,
        ),
        title: Text(
          theme.getUpText(context),
          style: theme.getUpTextStyle(context),
          textScaleFactor: theme.getUpTextScaleFactor(context),
        ),
      ),
      onTap: () {
        widget.onChange(this.widget.rootDirectory.parent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dirContents,
      builder: (BuildContext context,
          AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        final effectiveTheme =
            widget.theme ?? FilesystemPickerFileListThemeData();

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('Error loading file list: ${snapshot.error}',
                    textScaleFactor:
                        effectiveTheme.getTextScaleFactor(context, true)),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.length +
                  (widget.showGoUp ? (widget.isRoot ? 0 : 1) : 0),
              itemBuilder: (BuildContext context, int index) {
                if (widget.showGoUp && !widget.isRoot && index == 0) {
                  return _upNavigation(context, effectiveTheme);
                }

                final item = snapshot.data![
                    index - (widget.showGoUp ? (widget.isRoot ? 0 : 1) : 0)];
                return FilesystemListTile(
                  fsType: widget.fsType,
                  item: item,
                  folderIconColor: widget.folderIconColor,
                  onChange: widget.onChange,
                  onSelect: widget.onSelect,
                  fileTileSelectMode: widget.fileTileSelectMode,
                  theme: effectiveTheme,
                  caseSensitiveFileExtensionComparison:
                      widget.caseSensitiveFileExtensionComparison,
                );
              },
            );
          } else {
            return const SizedBox();
          }
        } else {
          return FilesystemProgressIndicator(theme: effectiveTheme);
        }
      },
    );
  }
}
