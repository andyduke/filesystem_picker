import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list_tile.dart';
import 'options/theme/_filelist_theme.dart';
import 'progress_indicator.dart';

typedef FilesystemListFilter = bool Function(FileSystemEntity fsEntity, String path, String name);

class FilesystemList extends StatefulWidget {
  final bool isRoot;
  final Directory rootDirectory;
  final FilesystemType fsType;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final FileTileSelectMode fileTileSelectMode;
  final FilesystemPickerFileListThemeData? theme;
  final bool showGoUp;
  final bool caseSensitiveFileExtensionComparison;
  final ScrollController? scrollController;
  final FilesystemListFilter? itemFilter;

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
  late Directory rootDirectory;
  Future<List<FileSystemEntity>>? _dirContents;

  @override
  void initState() {
    super.initState();

    rootDirectory = widget.rootDirectory;
    _loadDirContents();
  }

  @override
  void didUpdateWidget(covariant FilesystemList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!Path.equals(oldWidget.rootDirectory.absolute.path, widget.rootDirectory.absolute.path)) {
      rootDirectory = widget.rootDirectory;
      _loadDirContents();
    }
  }

  void _loadDirContents() async {
    if (!await rootDirectory.exists()) {
      setState(() {
        _dirContents = Future.error('The "${rootDirectory.path} path does not exist.');
      });
      return;
    }

    final List<String>? allowedExtensions = widget.caseSensitiveFileExtensionComparison
        ? widget.allowedExtensions
        : widget.allowedExtensions?.map((e) => e.toLowerCase()).toList(growable: false);

    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    var lister = rootDirectory.list(recursive: false);
    lister.listen(
      (file) {
        if (widget.itemFilter != null) {
          final localPath = Path.relative(file.path, from: rootDirectory.path);
          if (!widget.itemFilter!.call(file, rootDirectory.path, localPath)) return;
        }

        if ((widget.fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) && (allowedExtensions != null) && (allowedExtensions.length > 0)) {
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
        files.sort((a, b) => a.path.compareTo(b.path));
        completer.complete(files);
      },
    );

    setState(() {
      _dirContents = completer.future;
    });
  }

  InkWell _upNavigation(BuildContext context, FilesystemPickerFileListThemeData theme) {
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
        final li = this.widget.rootDirectory.path.split(Platform.pathSeparator)..removeLast();
        widget.onChange(Directory(li.join(Platform.pathSeparator)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dirContents,
      builder: (BuildContext context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        final effectiveTheme = widget.theme ?? FilesystemPickerFileListThemeData();

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text('Error loading file list: ${snapshot.error}',
                    textScaleFactor: effectiveTheme.getTextScaleFactor(context, true)),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.length + (widget.showGoUp ? (widget.isRoot ? 0 : 1) : 0),
              itemBuilder: (BuildContext context, int index) {
                if (widget.showGoUp && !widget.isRoot && index == 0) {
                  return _upNavigation(context, effectiveTheme);
                }

                final item = snapshot.data![index - (widget.showGoUp ? (widget.isRoot ? 0 : 1) : 0)];
                return FilesystemListTile(
                  fsType: widget.fsType,
                  item: item,
                  folderIconColor: widget.folderIconColor,
                  onChange: widget.onChange,
                  onSelect: widget.onSelect,
                  fileTileSelectMode: widget.fileTileSelectMode,
                  theme: effectiveTheme,
                  caseSensitiveFileExtensionComparison: widget.caseSensitiveFileExtensionComparison,
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
