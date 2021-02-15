import 'dart:io';
import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  void setThemeBrightness(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileSystem Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.accent,
        ),
        toggleableActiveColor: Colors.teal,
        brightness: _brightness,
      ),
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  Directory rootPath;

  String filePath;
  String dirPath;

  bool multiSelectMode = false;

  @override
  void initState() {
    super.initState();

    _prepareStorage();
  }

  Future<void> _prepareStorage() async {
    rootPath = await getTemporaryDirectory();

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

    setState(() {});
  }

  Future<void> _openFile(BuildContext context) async {
    var paths = await FilesystemPicker.open(
      title: 'Open file',
      context: context,
      fsType: FilesystemType.file,
      multiSelect: multiSelectMode,
      requestPermission: () async =>
      await Permission.storage
          .request()
          .isGranted,
      pickText: "Select File",
    );

    if (paths != null) {
      setState(() {
        filePath = paths.join("\n\n");
      });
    } else {
      setState(() {
        filePath = "";
      });
    }
  }

  Future<void> _pickDir(BuildContext context) async {
    var paths = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      //rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      multiSelect: multiSelectMode,
      requestPermission: () async =>
      await Permission.storage
          .request()
          .isGranted,
    );

    if (paths != null) {
      setState(() {
        dirPath = paths.join("\n\n");
      });
    } else {
      setState(() {
        dirPath = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);

    return Scaffold(
      body: Builder(
        builder: (context) =>
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Theme Brightness Switch Button
                    ElevatedButton(
                      child: Text((appState.brightness == Brightness.light)
                          ? 'Switch to Dark theme'
                          : 'Switch to Light theme'),
                      onPressed: () {
                        appState.setThemeBrightness(
                            appState.brightness == Brightness.light
                                ? Brightness.dark
                                : Brightness.light);
                      },
                    ),

                    Divider(height: 60),

                    // Directory picker section

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Directory Picker',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                    ),

                    if (dirPath != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('$dirPath'),
                      ),

                    ElevatedButton(
                      child: Text('Save File'),
                      onPressed:
                      (rootPath != null) ? () => _pickDir(context) : null,
                    ),

                    Divider(height: 60),

                    // File picker section

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'File Picker',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                    ),

                    if (filePath != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('$filePath'),
                      ),

                    ElevatedButton(
                      child: Text('Open File'),
                      onPressed:
                      (rootPath != null) ? () => _openFile(context) : null,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CheckboxListTile(
                        title: Text('Multi Select Mode'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: multiSelectMode,
                        onChanged: (bool newValue) {
                          setState(() {
                            multiSelectMode = newValue;
                          });
                        },
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
