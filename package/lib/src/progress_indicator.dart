import 'dart:async';
import 'package:flutter/material.dart';
import 'options/theme/_filelist_theme.dart';

class FilesystemProgressIndicator extends StatefulWidget {
  final FilesystemPickerFileListThemeData? theme;

  const FilesystemProgressIndicator({
    Key? key,
    this.theme,
  }) : super(key: key);

  @override
  State<FilesystemProgressIndicator> createState() =>
      _FilesystemProgressIndicatorState();
}

class _FilesystemProgressIndicatorState
    extends State<FilesystemProgressIndicator> {
  static const double _defaultSize = 32;
  static const double _defaultPadding = 8;
  static const Duration _delay = Duration(milliseconds: 100);

  Timer? _timer;
  bool _visible = false;

  void _start() {
    _timer = Timer(_delay, () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? FilesystemPickerFileListThemeData();

    return _visible
        ? Padding(
            padding: const EdgeInsets.all(_defaultPadding),
            child: Center(
              child: SizedBox(
                width: _defaultSize,
                height: _defaultSize,
                child: CircularProgressIndicator(
                  color: effectiveTheme.getProgressIndicatorColor(context),
                ),
              ),
            ),
          )
        : const SizedBox(
            width: _defaultSize + _defaultPadding,
            height: _defaultSize + _defaultPadding,
          );
  }
}
