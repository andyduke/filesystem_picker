import 'dart:io';

/// Normalizes root paths, making them valid for path navigation
Directory normalizeRootPath(Directory path) {
  // Add a trailing path separator to the root of a drive in Windows
  if (Platform.isWindows &&
      (path.path.length == 2) &&
      (path.path.substring(1, 2) == ':')) {
    return Directory(path.path + Platform.pathSeparator);
  } else {
    return path;
  }
}
