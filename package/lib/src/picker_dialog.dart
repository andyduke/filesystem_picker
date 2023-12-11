import 'package:flutter/material.dart';

import 'options/picker_options.dart';

class FilesystemPickerDialog extends StatelessWidget {
  final Widget child;
  final BoxConstraints? constraints;

  const FilesystemPickerDialog({
    Key? key,
    required this.child,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = FilesystemPickerDefaultOptions.of(context);

    return Dialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ConstrainedBox(
        constraints: constraints ?? options.dialog.constraints,
        child: child,
      ),
    );
  }
}
