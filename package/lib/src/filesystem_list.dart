import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'common.dart';
import 'filesystem_list_tile.dart';

class FilesystemList extends StatefulWidget {
  final bool isRoot;
  final Directory rootDirectory;
  final FilesystemType fsType;
  final Color? folderIconColor;
  final List<String>? allowedExtensions;
  final ValueChanged<Directory> onChange;
  final ValueSelected onSelect;
  final FileTileSelectMode fileTileSelectMode;

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
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilesystemListState();
}

class _FilesystemListState extends State<FilesystemList> {
  List<FileSystemEntity> _files = [];
  bool isDisposed = false;
  bool notReady = true;
  ScrollController controller = ScrollController();
  Map<String, double> positions = {};

  Future<List<FileSystemEntity>> _dirContents() {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    var lister = widget.rootDirectory.list(recursive: false);
    lister.listen(
          (file) {
        if ((widget.fsType != FilesystemType.folder) || (file is Directory)) {
          if ((file is File) &&
              (widget.allowedExtensions != null) &&
              (widget.allowedExtensions!.length > 0)) {
            if (!widget.allowedExtensions!.contains(Path.extension(file.path))) return;
          }
          files.add(file);
        }
      },
      onDone: () {
        files.sort((a, b) => a.path.compareTo(b.path));
        completer.complete(files);
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemCount: notReady ? 0 : (_files.length + (widget.isRoot ? 0 : 1)),
      itemBuilder: (BuildContext context, int index) {
        if (!widget.isRoot && index == 0) {
          return _topNavigation();
        }

        final item = _files[index - (widget.isRoot ? 0 : 1)];
        return FilesystemListTile(
          fsType: widget.fsType,
          item: item,
          folderIconColor: widget.folderIconColor,
          onChange: widget.onChange,
          onSelect: widget.onSelect,
          fileTileSelectMode: widget.fileTileSelectMode,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    setupList();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant FilesystemList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rootDirectory.absolute.path !=
        widget.rootDirectory.absolute.path) {
      setupList();
    }
  }


  InkWell _topNavigation() {
    return InkWell(
      child: const ListTile(
        leading: Icon(Icons.arrow_upward, size: 32),
        title: Text("..", textScaleFactor: 1.5),
      ),
      onTap: () {
        final li = widget.rootDirectory.path.split(Platform.pathSeparator)
          ..removeLast();
        widget.onChange(Directory(li.join(Platform.pathSeparator)));
      },
    );
  }

  void setupList() async {
    notReady = true;
    _files = await _dirContents();
    setState(() {
      notReady = false;
      String path = widget.rootDirectory.absolute.path;
      if (positions.containsKey(path))
        controller.jumpTo(positions[path]!);
    });
  }

  void onScroll() {
    if (!notReady) {
      positions[widget.rootDirectory.absolute.path] = controller.offset;
    }
  }
}