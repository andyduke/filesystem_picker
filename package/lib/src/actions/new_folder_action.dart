import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:filesystem_picker/src/actions/action.dart';
import 'package:filesystem_picker/src/actions/shakeable_dialogs.dart';
import 'package:flutter/material.dart';

/// The signature of the error message string interpolator when the folder being created already exists.
typedef FilesystemPickerNewFolderMessageBuilder = String Function(String value);

/// Defines the action to create a new folder.
class FilesystemPickerNewFolderContextAction extends FilesystemPickerContextAction {
  /// Title of the dialog for creating a new folder.
  final String? dialogTitle;

  /// Message in the dialog for creating a new folder.
  final String? dialogPrompt;

  /// The text of the "OK" button in the dialog for creating a new folder.
  final String? dialogOkText;

  /// The text of the "Cancel" button in the dialog for creating a new folder.
  final String? dialogCancelText;

  /// The interpolator of the error message string when the folder being created already exists.
  /// Default message: 'The folder with the name "&lt;new folder name&gt;" already exists. Please use another name.'
  final FilesystemPickerNewFolderMessageBuilder? alreadyExistsMessage;

  /// Creates an action definition.
  FilesystemPickerNewFolderContextAction({
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
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          // TODO: ContextActionsDialogTheme
          dialogBackgroundColor: Colors.blueGrey.shade100,
        ),
        child: FilesystemPickerNewFolderDialog(
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

/// A dialog asking for a name for the new folder.
class FilesystemPickerNewFolderDialog extends StatefulWidget {
  /// Dialog title.
  final String? title;

  /// Dialog message before the new folder name input field.
  final String? prompt;

  /// The text of the "OK" button.
  final String? okText;

  /// The text of the "Cancel" button.
  final String? cancelText;

  /// The handler called when the user specified the name of the new folder and clicked the "OK" button.
  final ValueChanged<String?> onDone;

  /// Creates a dialog asking for a name for the new folder.
  const FilesystemPickerNewFolderDialog({
    Key? key,
    this.title,
    this.prompt,
    this.okText,
    this.cancelText,
    required this.onDone,
  }) : super(key: key);

  @override
  State<FilesystemPickerNewFolderDialog> createState() => _FilesystemPickerNewFolderDialogState();
}

class _FilesystemPickerNewFolderDialogState extends State<FilesystemPickerNewFolderDialog> {
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
