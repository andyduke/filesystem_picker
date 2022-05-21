# FilesystemPicker example

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

void main() {
  runApp(const PickerApp());
}

class PickerApp extends StatelessWidget {
  const PickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Pick file'),
          onPressed: () async {
            final Directory rootPath = await getTemporaryDirectory();
            String? path = await FilesystemPicker.open(
              title: 'Pick file',
              context: context,
              rootDirectory: rootPath,
              fsType: FilesystemType.file,
              requestPermission: () async => await Permission.storage.request().isGranted,
            );
            debugPrint('File: $path');
          },
        ),
      ),
    );
  }
}
```

See more examples in the `example/lib` folder.
