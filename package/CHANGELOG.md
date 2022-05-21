## 3.0.0-beta.1

* Two new picker display modes: popup dialog and bottom sheet.
* Added the ability to specify the directory initially displayed in the dialog (must be a child of the `rootDirectory`).
* Added the ability to set a callback to filter the list of folders and files displayed in the picker.
* Added contextual actions such as "Create Folder".
* Added a theme definition that allows you to customize each part of the picker.
* The `FilesystemPickerDefaultOptions` widget has been added, which allows you to set the default settings and theme for all pickers.

## 2.0.0

* Deprecated theme properties have been replaced with their current counterpart.

## 2.0.0-nullsafety.0

* Migrate to null safety.

## 1.0.4

Bug fix: `FilesystemPicker.open()` now returns null if nothing was selected.

## 1.0.3

**Breaking change**
FileSystem Picker no longer checks storage access permissions. If you need it, you must do it via a callback.

* The explicit dependency on permission_handler has been removed and replaced with a callback.

## 1.0.2

* Added file item selection mode (checkmark or whole tile)

## 1.0.1

* Remove ripple effect on file selection tile
* Added optional folder icon color

## 1.0.0+2

* permission_handler dependency updated to 5.0.1

## 1.0.0+1

* pub.dev maintenance issues resolved.

## 1.0.0

* Initial release.
