import 'package:filesystem_picker/src/options/picker_bottom_sheet_options.dart';
import 'package:filesystem_picker/src/options/picker_dialog_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common.dart';
import 'theme/theme.dart';

/// Defines the options for the [FilesystemPicker], such as the theme, the name of the root element, etc.
///
/// It is used together with [FilesystemPickerDefaultOptions] to set global picker settings.
///
/// See also:
/// * [FilesystemPickerDefaultOptions] for an example of usage.
@immutable
class FilesystemPickerOptions with Diagnosticable {
  /// The default value of the name of the filesystem view root in breadcrumbs.
  static const String defaultRootName = 'Storage';

  /// The default value of the type of filesystem view (folder and files, folder only or files only).
  static const FilesystemType defaultFsType = FilesystemType.all;

  /// The default value of the text of the message that there is no permission to access the storage.
  static const String defaultPermissionText =
      'Access to the storage was not granted.';

  /// The default value of the file selection mode (either tapping on the whole tile or only on trailing button).
  static const FileTileSelectMode defaultFileTileSelectMode =
      FileTileSelectMode.checkButton;

  /// The default value of the option to display the go to the previous level of the file system in the filesystem view.
  static const bool defaultShowGoUp = true;

  /// The default value of the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive.
  static const bool defaultCaseSensitiveFileExtensionComparison = false;

  /// The default dialog options values.
  static const FilesystemPickerDialogOptions defaultDialogOptions =
      FilesystemPickerDialogOptions();

  /// The default bottom sheet options values.
  static const FilesystemPickerBottomSheetOptions defaultBottomSheetOptions =
      FilesystemPickerBottomSheetOptions();

  final FilesystemPickerThemeBase? _theme;

  /// The value of the name of the filesystem view root in breadcrumbs.
  final String? rootName;

  /// The value of the type of filesystem view (folder and files, folder only or files only).
  final FilesystemType fsType;

  /// The value of the text of the message that there is no permission to access the storage.
  final String permissionText;

  /// The value of the file selection mode (either tapping on the whole tile or only on trailing button).
  final FileTileSelectMode fileTileSelectMode;

  /// The value of the option to display the go to the previous level of the file system in the filesystem view.
  final bool showGoUp;

  /// The value of the mode of comparing extensions with the `allowedExtensions` list, case-sensitive or case-insensitive.
  final bool caseSensitiveFileExtensionComparison;

  /// The dialog options values.
  final FilesystemPickerDialogOptions dialog;

  /// The bottom sheet options values.
  final FilesystemPickerBottomSheetOptions bottomSheet;

  /// Creates the options for the [FilesystemPicker], such as the theme, the name of the root element, etc.
  const FilesystemPickerOptions({
    FilesystemPickerThemeBase? theme,
    this.rootName = defaultRootName,
    this.fsType = defaultFsType,
    this.permissionText = defaultPermissionText,
    this.fileTileSelectMode = defaultFileTileSelectMode,
    this.showGoUp = defaultShowGoUp,
    this.caseSensitiveFileExtensionComparison =
        defaultCaseSensitiveFileExtensionComparison,
    this.dialog = defaultDialogOptions,
    this.bottomSheet = defaultBottomSheetOptions,
  }) : _theme = theme;

  static FilesystemPickerOptions _defaultOptions(BuildContext context) {
    return const FilesystemPickerOptions();
  }

  /// Returns the current theme.
  FilesystemPickerThemeBase get theme =>
      _theme ?? const FilesystemPickerTheme();

  /// The hash code for this object.
  @override
  int get hashCode {
    return Object.hash(
      theme,
      rootName,
      fsType,
      permissionText,
      fileTileSelectMode,
      showGoUp,
      caseSensitiveFileExtensionComparison,
      dialog,
      bottomSheet,
    );
  }

  /// The equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerOptions &&
        other.theme == theme &&
        other.rootName == rootName &&
        other.fsType == fsType &&
        other.permissionText == permissionText &&
        other.fileTileSelectMode == fileTileSelectMode &&
        other.showGoUp == showGoUp &&
        other.caseSensitiveFileExtensionComparison ==
            caseSensitiveFileExtensionComparison &&
        other.dialog == dialog &&
        other.bottomSheet == bottomSheet;
  }

  /// Add additional properties associated with the node.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerThemeBase>(
        'theme', theme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<String>('rootName', rootName,
        defaultValue: defaultRootName));
    properties.add(DiagnosticsProperty<FilesystemType>('fsType', fsType,
        defaultValue: defaultFsType));
    properties.add(DiagnosticsProperty<String>('permissionText', permissionText,
        defaultValue: defaultPermissionText));
    properties.add(DiagnosticsProperty<FileTileSelectMode>(
        'fileTileSelectMode', fileTileSelectMode,
        defaultValue: defaultFileTileSelectMode));
    properties.add(DiagnosticsProperty<bool>('showGoUp', showGoUp,
        defaultValue: defaultShowGoUp));
    properties.add(DiagnosticsProperty<bool>(
        'caseSensitiveFileExtensionComparison',
        caseSensitiveFileExtensionComparison,
        defaultValue: defaultCaseSensitiveFileExtensionComparison));
    properties.add(DiagnosticsProperty<FilesystemPickerDialogOptions>(
        'dialog', dialog,
        defaultValue: defaultDialogOptions));
    properties.add(DiagnosticsProperty<FilesystemPickerBottomSheetOptions>(
        'bottomSheet', bottomSheet,
        defaultValue: defaultBottomSheetOptions));
  }
}

/// Sets global default values for the picker options and the default theme.
///
/// This widget must be placed above the `Navigator` widget so that its context
/// is accessible to the picker's dialog/bottom sheet.
///
/// Usually it should be placed above the `MaterialApp` or `CupertinoApp` widget.
///
/// Example:
/// ```dart
/// class MyApp extends StatelessWidget {
///
///   @override
///   Widget build(BuildContext context) {
///     return FilesystemPickerDefaultOptions(
///       fileTileSelectMode: FileTileSelectMode.wholeTile,
///       theme: FilesystemPickerAutoSystemTheme(
///         ...
///       ),
///       child: MaterialApp(
///         ...
///       ),
///     );
///   }
///
/// }
/// ```
class FilesystemPickerDefaultOptions extends StatefulWidget {
  /// Default FilesystemPicker options.
  final FilesystemPickerOptions options;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a default picker options widget.
  FilesystemPickerDefaultOptions({
    Key? key,
    required this.child,
    FilesystemPickerThemeBase? theme,
    String? rootName,
    FilesystemType fsType = FilesystemPickerOptions.defaultFsType,
    String permissionText = FilesystemPickerOptions.defaultPermissionText,
    FileTileSelectMode fileTileSelectMode =
        FilesystemPickerOptions.defaultFileTileSelectMode,
    bool showGoUp = FilesystemPickerOptions.defaultShowGoUp,
    FilesystemPickerDialogOptions dialog =
        FilesystemPickerOptions.defaultDialogOptions,
    FilesystemPickerBottomSheetOptions bottomSheet =
        FilesystemPickerOptions.defaultBottomSheetOptions,
  })  : options = FilesystemPickerOptions(
          theme: theme,
          rootName: rootName,
          fsType: fsType,
          permissionText: permissionText,
          fileTileSelectMode: fileTileSelectMode,
          showGoUp: showGoUp,
          dialog: dialog,
          bottomSheet: bottomSheet,
        ),
        super(key: key);

  @override
  State<FilesystemPickerDefaultOptions> createState() =>
      FilesystemPickerDefaultOptionsState();

  // @deprecated
  // static FilesystemPickerDefaultOptionsState? maybeOf(BuildContext context) =>
  //     context.dependOnInheritedWidgetOfExactType<_FilesystemPickerOptionsScope>()?.options;

  /// Returns the closest [FilesystemPickerOptions] which encloses the given context.
  static FilesystemPickerOptions of(BuildContext context) => (context
          .dependOnInheritedWidgetOfExactType<_FilesystemPickerOptionsScope>()
          ?.options
          .defaultOptions
          .options ??
      FilesystemPickerOptions._defaultOptions(context));
}

/// State associated with a [FilesystemPickerDefaultOptions] widget.
class FilesystemPickerDefaultOptionsState
    extends State<FilesystemPickerDefaultOptions> {
  FilesystemPickerDefaultOptions get defaultOptions => widget;

  @override
  Widget build(BuildContext context) {
    assert(
      Navigator.maybeOf(context) == null,
      'The FilesystemPickerDefaultOptions widget must be above the Navigator.\n\nThis can be achieved by placing it above MaterialApp/CupertinoApp or by using the builder callback on the MaterialApp/CupertinoApp widget.',
    );

    return _FilesystemPickerOptionsScope(
      options: this,
      child: widget.child,
    );
  }
}

class _FilesystemPickerOptionsScope extends InheritedWidget {
  final FilesystemPickerDefaultOptionsState options;

  const _FilesystemPickerOptionsScope({
    Key? key,
    required this.options,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant _FilesystemPickerOptionsScope oldWidget) =>
      oldWidget.options.defaultOptions.options !=
      options.defaultOptions.options;
}
