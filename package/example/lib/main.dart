import 'dart:io';
import 'package:filesystem_picker_example/screens/breadcrumbs_demo_screen.dart';
import 'package:filesystem_picker_example/screens/custom_theme_demo_screen.dart';
import 'package:filesystem_picker_example/screens/simple_demo_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const PickerDemoApp());
}

class PickerDemoApp extends StatefulWidget {
  const PickerDemoApp({Key? key}) : super(key: key);

  @override
  State<PickerDemoApp> createState() => _PickerDemoAppState();
}

class _PickerDemoAppState extends State<PickerDemoApp> {
  @override
  void initState() {
    super.initState();

    _prepareStore();
  }

  void _prepareStore() async {
    final Directory rootPath = await getTemporaryDirectory();

    // Create sample directory if not exists
    Directory sampleFolder = Directory('${rootPath.path}/Sample folder');
    if (!sampleFolder.existsSync()) {
      sampleFolder.createSync();
    }

    // Create sample file if not exists
    File sampleFile = File('${sampleFolder.path}/Sample.txt');
    if (!sampleFile.existsSync()) {
      sampleFile.writeAsStringSync('FileSystem Picker sample file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileSystemPicker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: const Text('Simple Demo'),
                  onPressed: () => Navigator.maybeOf(context)?.push(
                    MaterialPageRoute(
                      builder: (context) => SimpleDemoScreen(),
                    ),
                  ),
                ),

                //
                const SizedBox(height: 24),

                //
                ElevatedButton(
                  child: const Text('Custom Theme Demo'),
                  onPressed: () => Navigator.maybeOf(context)?.push(
                    MaterialPageRoute(
                      builder: (context) => CustomThemeDemoScreen(),
                    ),
                  ),
                ),

                //
                const SizedBox(height: 24),

                //
                ElevatedButton(
                  child: const Text('Breadcrumbs Demo'),
                  onPressed: () => Navigator.maybeOf(context)?.push(
                    MaterialPageRoute(
                      builder: (context) => const BreadcrumbsDemoScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
