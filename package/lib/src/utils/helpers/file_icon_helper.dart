import 'package:flutter/material.dart';

class FileIconHelper {
  /// Set the icon for a file
  static double iconSize = 32;

  static Icon getIcon(String filename, Color color) {
    var icon = Icons.description;

    final _extension = filename.split('.').last;
    if (_extension == 'db' ||
        _extension == 'sqlite' ||
        _extension == 'sqlite3') {
      icon = Icons.dns;
    } else if (_extension == 'jpg' ||
        _extension == 'jpeg' ||
        _extension == 'bmp' ||
        _extension == 'png') {
      icon = Icons.image;
    }
    // default
    return Icon(
      icon,
      color: color,
      size: iconSize,
    );
  }
}