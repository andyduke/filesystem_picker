import 'dart:io';
import 'package:flutter/widgets.dart';

/// Handler of the specified action signature.
typedef FilesystemPickerContextActionCallback = Future<bool> Function(
    BuildContext context, Directory path);

/// Defines an action that can be called for the current path, such as "Create Folder".
class FilesystemPickerContextAction {
  /// Action icon.
  final Widget icon;

  /// Action name.
  final String text;

  /// The handler called for the action.
  final FilesystemPickerContextActionCallback? action;

  /// Creates an action definition.
  FilesystemPickerContextAction({
    required this.icon,
    required this.text,
    this.action,
  });

  /// Called when the user tapped on a button or menu item of a contextual action.
  Future<bool> call(BuildContext context, Directory path) {
    return action?.call(context, path) ?? Future.value(false);
  }
}
