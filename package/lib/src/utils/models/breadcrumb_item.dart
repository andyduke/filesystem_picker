import 'package:flutter/foundation.dart';

class BreadcrumbItem<T> {
  // item text
  final String text;

  // item related data
  final T? data;

  // item select event
  final ValueChanged<T>? onSelect;

  BreadcrumbItem({
    required this.text,
    this.data,
    this.onSelect,
  });
}
