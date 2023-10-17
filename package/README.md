# FileSystem Picker

FileSystem file or folder picker dialog.

Allows the user to browse the file system and pick a folder or file.

## Table of Contents

- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Fullscreen Dialog](#fullscreen-dialog)
  - [Popup Dialog](#popup-dialog)
  - [Bottom Sheet](#bottom-sheet)
- [Customization](#customization)
- [Context Actions](#context-actions)
- [Shortcuts](#shortcuts)
- [Android permissions](#android-permissions)
- [Folder pick example](#folder-pick-example)
- [File pick example](#file-pick-example)

## Getting Started

In your flutter project add the dependency:

```dart
dependencies:
  ...
  filesystem_picker: ^4.0.0
```

Import package:
```dart
import 'package:filesystem_picker/filesystem_picker.dart';
```

## Usage

You can open picker in three different ways: a fullscreen dialog, a popup dialog, and a bottom sheet dialog.

![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/types_of_picker.png)

### Fullscreen Dialog

To open the dialog, use the asynchronous `FilesystemPicker.open` method. The method returns the path to the selected folder or file as a string.
The method takes the following parameters:
* **context** - widget tree context, required parameter;
* **rootDirectory** - the root path to view the filesystem;
* **rootName** - specifies the name of the filesystem view root in breadcrumbs, by default "Storage";
* **directory** - specifies the current path, which should be opened in the filesystem view by default (if not specified, the `rootDirectory` is used); **attention:** this path must be inside `rootDirectory`;
* **fsType** - specifies the type of filesystem view (folder and files, folder only or files only), by default `FilesystemType.all`;
* **pickText** - specifies the text for the folder selection button (only for `fsType` = `FilesystemType.folder`);
* **permissionText** - specifies the text of the message that there is no permission to access the storage, by default: "Access to the storage was not granted.";
* **title** - specifies the text of the dialog title;
* **showGoUp** - specifies the option to display the go to the previous level of the file system in the filesystem view; the default is true;
* **allowedExtensions** - specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['.jpg', '.jpeg']`;
* **caseSensitiveFileExtensionComparison** - specifies the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive; the default is false (case-insensitive);
* **fileTileSelectMode** - specifies the mode for selecting the file item (checkmark on the right or whole tile), by default: checkmark;
* **requestPermission** - specifies the callback to request storage permission, callers can use e.g. [permission_handler](https://pub.dev/packages/permission_handler);
* **folderIconColor** - specifies the folder icon color;
* **itemFilter** - specifies a callback to filter the displayed files in the filesystem view (not set by default); the filesystem entity, path to the file/directory and its name are passed to the callback, the callback should return a boolean value - to display the file/directory or not;
* **theme** - specifies a [picker theme](#customization) in which colors, fonts, icons, etc. can be customized; if not specified, takes values from `FilesystemPickerDefaultOptions`, if it is defined higher in the widget tree;
* **contextActions** - specifies a list of [actions](#context-actions), such as "Create Folder", which are placed in the upper right corner of the picker.
* **shortcuts** - specifies a list of [shortcuts](#shortcuts) that allow you to specify multiple root drives (for example, in Windows) or favorite paths (as in Linux/MacOS).

Be sure to specify either the `rootDirectory` or a non-empty list of `shortcuts`.

> **Attention!** You must ensure that you provide a valid path as the `rootDirectory` value.

### Popup Dialog

To open the popup dialog, use the asynchronous `FilesystemPicker.openDialog` method. The basic parameters are the same as in `open` (see [Fullscreen Dialog](#fullscreen-dialog)).

Additional parameter:
* **constraints** - specifies the size constraints to apply to the dialog.

### Bottom Sheet

To open the bottom sheet, use the asynchronous `FilesystemPicker.openBottomSheet` method. The basic parameters are the same as in `open` (see [Fullscreen Dialog](#fullscreen-dialog)).

Additional parameters:
* **constraints** - specifies the size constraints to apply to the bottom sheet;
* **barrierColor** - specifies the color of the modal barrier that darkens everything below the bottom sheet; if null the default transparent color is used;
* **shape** - specifies the shape of the bottom sheet; the default is an 8dp top rounded shape;
* **elevation** - specifies the z-coordinate at which to place this material relative to its parent; the default value is 24;
* **initialChildSize** - specifies the initial fractional value of the parent container's height to use when displaying the widget; the default value is 0.8;
* **minChildSize** - specifies the minimum fractional value of the parent container's height to use when displaying the widget; the default value is 0.6;
* **maxChildSize** - specifies the maximum fractional value of the parent container's height to use when displaying the widget; the default value is 0.96.

## Customization

The appearance and behavior of the picker can be highly customized. This can be done by configuring using the parameters of the `open`, `openDialog`, `openBottomSheet` methods, as well as passing the `FilesystemPickerTheme` object to the `theme` parameter.

![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/picker_customization.png)

Also, using the `FilesystemPickerDefaultOptions` widget, you can set the default settings and theme that will be used when using the `open`, `openDialog`, `openBottomSheet` methods (except for those settings that are set directly in the parameters of these methods).

**Attention!** This widget must be placed above the `Navigator` widget so that its context is accessible to the picker's dialog/bottom sheet.

Usually it should be placed above the `MaterialApp` or `CupertinoApp` widget.

```dart
class PickerApp extends StatelessWidget {
  const PickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilesystemPickerDefaultOptions(
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      theme: FilesystemPickerTheme(
        topBar: FilesystemPickerTopBarThemeData(
          backgroundColor: Colors.teal,
        ),
      ),
      child: MaterialApp(
        ...
      ),
    );
  }
}
```

To set up a light and dark theme with automatic switching depending on the `MaterialApp` or `CupertinoApp` settings, you can use the `FilesystemPickerAutoSystemTheme` widget.

```dart
class PickerApp extends StatelessWidget {
  const PickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilesystemPickerDefaultOptions(
      ...
      theme: FilesystemPickerAutoSystemTheme(
        lightTheme: FilesystemPickerTheme(
          ...
        ),
        darkTheme: FilesystemPickerTheme(
          ...
        ),
      ),
      child: MaterialApp(
        ...
      ),
    );
  }
}
```

## Context Actions

Using the `contextActions` parameter, you can set actions for the currently displayed folder, for example, "Create Folder".

If there is only one action, then a button for calling this action will be displayed in the upper right corner of the picker. If several actions are set, a pop-up menu button will be displayed.

```dart
String? path = await FilesystemPicker.open(
  ...
  contextActions: [
    FilesystemPickerNewFolderContextAction(),
  ],
);
```

![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/context_actions.png)

## Shortcuts

Shortcuts are a way to specify multiple root directories (instead of `rootDirectory`), or multiple drives (for example on Windows).

If you are specifying a list of shortcuts, then you do not need to specify the `rootDirectory`.

> **Attention!** You must ensure that you provide a valid path as the `Shortcut.path` value.

Shortcuts will be displayed at the beginning of the breadcrumbs, when selecting shortcuts in breadcrumbs you will see a list of shortcuts instead of a list of the file system, in which you can select the shortcut as the root of the file system display.

```dart
String? path = await FilesystemPicker.open(
  ...
  shortcuts: [
    FilesystemPickerShortcut(name: 'Documents', path: docsPath, icon: Icons.snippet_folder),
    FilesystemPickerShortcut(name: 'Temporary', path: tempPath),
  ],
);
```

![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/shortcuts.png)

## Android permissions

To access the filesystem in Android, you must specify access permissions in the `AndroidManifest.xml` file, for example:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_INTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

## Folder pick example

```dart
String path = await FilesystemPicker.open(
  title: 'Save to folder',
  context: context,
  rootDirectory: rootPath,
  fsType: FilesystemType.folder,
  pickText: 'Save file to this folder',
);
```
![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/folder_pick.png)

## File pick example

```dart
String path = await FilesystemPicker.open(
  title: 'Open file',
  context: context,
  rootDirectory: rootPath,
  fsType: FilesystemType.file,
  allowedExtensions: ['.txt'],
  fileTileSelectMode: FileTileSelectMode.wholeTile,
);
```
![](https://github.com/andyduke/filesystem_picker/raw/master/screenshots/file_pick.png)
