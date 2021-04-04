import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';

enum FilesystemType {
  all,
  folder,
  file,
}

typedef ValueSelected = void Function(String value, bool isSelected, FileSystemEntityType type);
typedef RequestPermission = Future<bool> Function();

// Stack structure list implementation
class StackList<T> {
  final _stack = Queue<T>();

  // put new item to the top of Stack
  void push(T element) {
    _stack.addLast(element);
  }

  // remove topmost item from the stack, and return it
  T pop() {
    T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  // return topmost item from the stack, without removing it
  T peek() {
    return _stack.last;
  }

  int get length => _stack.length;
}

/// Set the icon for a file
double iconSize = 32;

Icon fileIcon(String filename, Color color) {
  IconData icon = Icons.description;

  final _extension = filename
      .split(".")
      .last;
  if (_extension == "db" ||
      _extension == "sqlite" ||
      _extension == "sqlite3") {
    icon = Icons.dns;
  } else if (_extension == "jpg" ||
      _extension == "jpeg" ||
      _extension == "bmp" ||
      _extension == "png") {
    icon = Icons.image;
  }
  // default
  return Icon(
    icon,
    color: color,
    size: iconSize,
  );
}

final fseHBorder = Container(
  height: 1,
  color: Colors.grey,
);