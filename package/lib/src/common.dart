enum FilesystemType {
  all,
  folder,
  file,
}

typedef ValueSelected = void Function(String value);
typedef RequestPermission = Future<bool> Function();

/// Mode for selecting files. Either only the button in the trailing
/// of ListTile, or onTap of the whole ListTile.
enum FileTileSelectMode {
  checkButton,
  wholeTile,
}
