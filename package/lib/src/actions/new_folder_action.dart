import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:filesystem_picker/src/actions/action.dart';
import 'package:filesystem_picker/src/actions/shakeable_dialogs.dart';
import 'package:flutter/material.dart';

typedef FilesystemPickerNewFolderMessageBuilder = String Function(String value);

class FilesystemPickerNewFolderAction extends FilesystemPickerAction {
  final String? dialogTitle;
  final String? dialogPrompt;
  final String? dialogOkText;
  final String? dialogCancelText;

  ///
  /// Default: 'The folder with the name "<new folder name>" already exists. Please use another name.'
  final FilesystemPickerNewFolderMessageBuilder? alreadyExistsMessage;

  FilesystemPickerNewFolderAction({
    super.icon = const Icon(Icons.create_new_folder),
    super.text = 'New folder',
    this.dialogTitle,
    this.dialogPrompt,
    this.dialogOkText,
    this.dialogCancelText,
    this.alreadyExistsMessage,
  }) : super(
          action: (context, path) => _createNewFolder(
            context,
            path,
            title: dialogTitle,
            prompt: dialogPrompt,
            okText: dialogOkText,
            cancelText: dialogCancelText,
            alreadyExistsMessage: alreadyExistsMessage,
          ),
        );

  static Future<bool> _createNewFolder(
    BuildContext context,
    Directory path, {
    String? title,
    String? prompt,
    String? okText,
    String? cancelText,
    FilesystemPickerNewFolderMessageBuilder? alreadyExistsMessage,
  }) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => NewFolderDialog(
        title: title,
        prompt: prompt,
        okText: okText,
        cancelText: cancelText,
        onDone: (value) async {
          if (value != null) {
            try {
              if (!await _createFolder(path, value)) {
                final message = (alreadyExistsMessage != null)
                    ? alreadyExistsMessage.call(value)
                    : 'The folder with the name "$value" already exists. Please use another name.';

                await _showError(context, message);
                return;
              }
            } catch (e) {
              // debugPrint('Error: ${e.runtimeType}');

              await _showError(context, '$e');
              return;
            }
          }
          Navigator.maybeOf(context)?.pop(true);
        },
      ),
    );
    return (result == true);
  }

  static Future<void> _showError(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.maybeOf(context)?.pop(),
          ),
        ],
      ),
    );
  }

  static Future<bool> _createFolder(Directory parent, String folderName) async {
    // debugPrint('Create folder: "$folderName" in "$parent".');

    final newDirectory = Directory(p.join(parent.path, folderName));

    if (await newDirectory.exists()) {
      return false;
    } else {
      await newDirectory.create();
      return true;
    }
  }
}

class NewFolderDialog extends StatefulWidget {
  final String? title;
  final String? prompt;
  final String? okText;
  final String? cancelText;
  final ValueChanged<String?> onDone;

  const NewFolderDialog({
    Key? key,
    this.title,
    this.prompt,
    this.okText,
    this.cancelText,
    required this.onDone,
  }) : super(key: key);

  @override
  State<NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<NewFolderDialog> {
  final ShakeableController _shakeController = ShakeableController();
  String? _folderName;

  @override
  Widget build(BuildContext context) {
    return ShakeableAnimation(
      controller: _shakeController,
      child: AlertDialog(
        title: Text(widget.title ?? 'New folder'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prompt?.isNotEmpty ?? true)
              Text(
                widget.prompt ?? 'Please enter new folder name',
              ),
            TextField(
              autofocus: true,
              onChanged: (value) => _folderName = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text((widget.cancelText ?? 'Cancel').toUpperCase()),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.button?.color,
            ),
            onPressed: () {
              Navigator.maybeOf(context)?.pop();
            },
          ),
          TextButton(
            child: Text((widget.okText ?? 'OK').toUpperCase()),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (_folderName?.isNotEmpty ?? false) {
                widget.onDone.call(_folderName);
              } else {
                _shakeController.shake();
              }
            },
          ),
        ],
      ),
    );
  }
}
