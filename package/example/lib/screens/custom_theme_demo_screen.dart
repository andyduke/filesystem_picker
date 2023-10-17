import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:filesystem_picker_example/screens/widgets/demo_scaffold.dart';
import 'package:filesystem_picker_example/screens/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomThemeDemoScreen extends StatelessWidget {
  CustomThemeDemoScreen({Key? key}) : super(key: key);

  final ValueNotifier<String?> selectedPath = ValueNotifier(null);

  FilesystemPickerThemeBase _buildTheme() {
    return FilesystemPickerAutoSystemTheme(
      darkTheme: FilesystemPickerTheme(
        topBar: FilesystemPickerTopBarThemeData(
          backgroundColor: const Color(0xFF4B4B4B),
        ),
        fileList: FilesystemPickerFileListThemeData(
          folderIconColor: Colors.teal.shade400,
        ),
      ),
      lightTheme: FilesystemPickerTheme(
        backgroundColor: Colors.grey.shade200,
        topBar: FilesystemPickerTopBarThemeData(
          foregroundColor: Colors.blueGrey.shade800,
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          shape: const ContinuousRectangleBorder(
            side: BorderSide(
              color: Color(0xFFDDDDDD),
              width: 1.0,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
            opacity: 0.3,
            size: 32,
          ),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.blueGrey.shade600,
          ),
          breadcrumbsTheme: BreadcrumbsThemeData(
            itemColor: Colors.blue.shade800,
            inactiveItemColor: Colors.blue.shade800.withOpacity(0.6),
            separatorColor: Colors.blue.shade800.withOpacity(0.3),
          ),
        ),
        fileList: FilesystemPickerFileListThemeData(
          iconSize: 32,
          folderIcon: Icons.folder_open,
          folderIconColor: Colors.orange,
          folderTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.blueGrey.shade700),
          fileIcon: Icons.description_outlined,
          fileIconColor: Colors.deepOrange,
          fileTextStyle: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          upIcon: Icons.drive_folder_upload,
          upIconSize: 32,
          upIconColor: Colors.pink,
          upText: '<up-dir>',
          upTextStyle: const TextStyle(fontSize: 18, color: Colors.pink),
          checkIcon: Icons.check_box,
          checkIconColor: Colors.purple,
          progressIndicatorColor: Colors.pink,
        ),
        pickerAction: FilesystemPickerActionThemeData(
          foregroundColor: Colors.blueGrey.shade800,
          disabledForegroundColor: Colors.blueGrey.shade500,
          backgroundColor: Colors.grey.shade200,
          shape: const ContinuousRectangleBorder(
            side: BorderSide(
              color: Color(0xFFDDDDDD),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

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
        theme: _buildTheme(),
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
        theme: _buildTheme(),
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
        theme: _buildTheme(),
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
        theme: _buildTheme(),
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
        theme: _buildTheme(),
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
        theme: _buildTheme(),
      );

      selectedPath.value = path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Custom Theme Demo',
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
