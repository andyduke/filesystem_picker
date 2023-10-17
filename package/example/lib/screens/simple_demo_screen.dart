import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:filesystem_picker_example/screens/widgets/demo_scaffold.dart';
import 'package:filesystem_picker_example/screens/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SimpleDemoScreen extends StatelessWidget {
  SimpleDemoScreen({Key? key}) : super(key: key);

  final ValueNotifier<String?> selectedPath = ValueNotifier(null);

  // --- Fullscreen Dialog

  void _pickFolder(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.open(
        title: 'Select folder',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.folder,
        pickText: 'Select folder',
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
      );

      selectedPath.value = path;
    }
  }

  void _pickFile(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.open(
        title: 'Open file',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.file,
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
      );

      selectedPath.value = path;
    }
  }

  // --- Dialog

  void _pickFolderDialog(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.openDialog(
        title: 'Select folder',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.folder,
        pickText: 'Select folder',
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
        constraints: const BoxConstraints(
          maxWidth: 280,
          maxHeight: 460,
        ),
      );

      selectedPath.value = path;
    }
  }

  void _pickFileDialog(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.openDialog(
        title: 'Open file',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.file,
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
      );

      selectedPath.value = path;
    }
  }

  // --- Bottom Sheet

  void _pickFolderBottomSheet(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.openBottomSheet(
        title: 'Select folder',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.folder,
        pickText: 'Select folder',
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
        constraints: const BoxConstraints(
          maxWidth: 280,
          maxHeight: 460,
        ),
      );

      selectedPath.value = path;
    }
  }

  void _pickFileBottomSheet(BuildContext context) async {
    selectedPath.value = null;

    final Directory rootPath = await getTemporaryDirectory();

    debugPrint('Root path: ${rootPath.absolute.path}');

    if (context.mounted) {
      String? path = await FilesystemPicker.openBottomSheet(
        title: 'Open file',
        context: context,
        rootDirectory: rootPath,
        fsType: FilesystemType.file,
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
      );

      selectedPath.value = path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Simple Demo',
      bottom: ValueListenableBuilder(
        valueListenable: selectedPath,
        builder: (context, value, child) =>
            Text('Selected: ${value ?? 'none'}'),
      ),
      children: [
        const Heading(text: 'Fullscreen Dialog'),

        //
        ElevatedButton(
          child: const Text('Select folder'),
          onPressed: () => _pickFolder(context),
        ),

        //
        const Divider(height: 24),

        ElevatedButton(
          child: const Text('Pick file'),
          onPressed: () => _pickFile(context),
        ),

        //
        const Heading(text: 'Dialog'),

        //
        ElevatedButton(
          child: const Text('Select folder'),
          onPressed: () => _pickFolderDialog(context),
        ),

        //
        const Divider(height: 24),

        ElevatedButton(
          child: const Text('Pick file'),
          onPressed: () => _pickFileDialog(context),
        ),

        //
        const Heading(text: 'Bottom Sheet'),

        //
        ElevatedButton(
          child: const Text('Select folder'),
          onPressed: () => _pickFolderBottomSheet(context),
        ),

        //
        const Divider(height: 24),

        ElevatedButton(
          child: const Text('Pick file'),
          onPressed: () => _pickFileBottomSheet(context),
        ),

        //
        const SizedBox(height: 32),
      ],
    );
  }
}
