class PathItem {
  final String text;
  final String path;

  PathItem({
    required this.path,
    required this.text,
  });

  @override
  String toString() {
    return '$text: $path';
  }
}
