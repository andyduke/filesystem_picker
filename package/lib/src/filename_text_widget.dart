import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

// Handles long filenames better, by adding ellipsis right before the file extension (if any)
class FilenameTextWidget extends StatelessWidget {
  final String filename;
  final bool isDirectory;
  final TextStyle? textStyle;

  const FilenameTextWidget(this.filename, {required this.isDirectory, this.textStyle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txTheme = textStyle ?? Theme.of(context).textTheme.bodyText1;

    final fseName = Path.basename(filename);
    final extension =  Path.extension(fseName);
    final hasExtension = extension.isNotEmpty;
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(isDirectory == false && hasExtension ? fseName.split(extension)[0] : fseName,
              textScaleFactor: 1.2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: txTheme
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
