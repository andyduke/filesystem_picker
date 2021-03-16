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
