import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// Handles long filenames better, by adding ellipsis right before the file extension (if any)
class FilenameText extends StatelessWidget {
  final String filename;
  final bool isDirectory;
  final TextStyle? textStyle;

  const FilenameText(
    this.filename, {
    required this.isDirectory,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txTheme = textStyle ?? Theme.of(context).textTheme.bodyText1;
    final fseName = path.basename(filename);
    final extension = path.extension(fseName);
    final hasExtension = extension.isNotEmpty;
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            isDirectory == false && hasExtension
                ? fseName.split(extension)[0]
                : fseName,
            textScaleFactor: 1.2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: txTheme,
          ),
        ),
        Text(
          extension,
          textScaleFactor: 1.2,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: txTheme,
        ),
      ],
    );
  }
}
