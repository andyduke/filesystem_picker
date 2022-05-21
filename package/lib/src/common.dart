/// Enumeration with options for display types of the file system.
enum FilesystemType {
  /// Folders and files
  all,

  /// Folders only
  folder,

  /// Files only
  file,
}

/// Value selection signature.
typedef ValueSelected = void Function(String value);

/// Access permission request signature.
typedef RequestPermission = Future<bool> Function();

/// Mode for selecting files. Either only the button in the trailing
/// of row, or onTap of the whole row.
enum FileTileSelectMode {
  /// The file is selected only by tapping the button to the right of the file name.
  checkButton,

  /// The file is selected by tapping on the entire row of the list.
  wholeTile,
}
