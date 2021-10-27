import 'package:filesystem_picker/src/options/picker_bottom_sheet_options.dart';
import 'package:filesystem_picker/src/options/picker_dialog_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common.dart';
import 'theme/theme.dart';
import 'theme/theme_base.dart';

@immutable
class FilesystemPickerOptions with Diagnosticable {
  static const String defaultRootName = 'Storage';
  static const FilesystemType defaultFsType = FilesystemType.all;
  static const String defaultPermissionText = 'Access to the storage was not granted.';
  static const FileTileSelectMode defaultFileTileSelectMode = FileTileSelectMode.checkButton;
  static const bool defaultShowGoUp = true;
  static const bool defaultCaseSensitiveFileExtensionComparison = false;
  static const FilesystemPickerDialogOptions defaultDialogOptions = const FilesystemPickerDialogOptions();
  static const FilesystemPickerBottomSheetOptions defaultBottomSheetOptions =
      const FilesystemPickerBottomSheetOptions();

  final FilesystemPickerThemeBase? _theme;
  final String? rootName;
  final FilesystemType fsType;
  final String permissionText;
  final FileTileSelectMode fileTileSelectMode;
  final bool showGoUp;
  final bool caseSensitiveFileExtensionComparison;

  final FilesystemPickerDialogOptions dialog;
  final FilesystemPickerBottomSheetOptions bottomSheet;

  const FilesystemPickerOptions({
    FilesystemPickerThemeBase? theme,
    this.rootName = defaultRootName,
    this.fsType = defaultFsType,
    this.permissionText = defaultPermissionText,
    this.fileTileSelectMode = defaultFileTileSelectMode,
    this.showGoUp = defaultShowGoUp,
    this.caseSensitiveFileExtensionComparison = defaultCaseSensitiveFileExtensionComparison,
    this.dialog = defaultDialogOptions,
    this.bottomSheet = defaultBottomSheetOptions,
  }) : _theme = theme;

  static FilesystemPickerOptions _defaultOptions(BuildContext context) {
    return FilesystemPickerOptions();
  }

  FilesystemPickerThemeBase get theme => _theme ?? FilesystemPickerTheme.light();

  @override
  int get hashCode {
    return hashValues(
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
        other.caseSensitiveFileExtensionComparison == caseSensitiveFileExtensionComparison &&
        other.dialog == dialog &&
        other.bottomSheet == bottomSheet;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerThemeBase>('theme', theme, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('rootName', rootName, defaultValue: defaultRootName));
    properties.add(DiagnosticsProperty<FilesystemType>('fsType', fsType, defaultValue: defaultFsType));
    properties.add(DiagnosticsProperty<String>('permissionText', permissionText, defaultValue: defaultPermissionText));
    properties.add(DiagnosticsProperty<FileTileSelectMode>('fileTileSelectMode', fileTileSelectMode,
        defaultValue: defaultFileTileSelectMode));
    properties.add(DiagnosticsProperty<bool>('showGoUp', showGoUp, defaultValue: defaultShowGoUp));
    properties.add(DiagnosticsProperty<bool>(
        'caseSensitiveFileExtensionComparison', caseSensitiveFileExtensionComparison,
        defaultValue: defaultCaseSensitiveFileExtensionComparison));
    properties
        .add(DiagnosticsProperty<FilesystemPickerDialogOptions>('dialog', dialog, defaultValue: defaultDialogOptions));
    properties.add(DiagnosticsProperty<FilesystemPickerBottomSheetOptions>('bottomSheet', bottomSheet,
        defaultValue: defaultBottomSheetOptions));
  }
}

class FilesystemPickerDefaultOptions extends StatefulWidget {
  final Widget child;
  final FilesystemPickerOptions options;

  /*
  FilesystemPickerDefaultOptions({
    Key? key,
    required this.child,
    required this.options,
  }) : super(key: key);
  */

  FilesystemPickerDefaultOptions({
    Key? key,
    required this.child,
    FilesystemPickerThemeBase? theme,
    String? rootName,
    FilesystemType fsType = FilesystemPickerOptions.defaultFsType,
    String permissionText = FilesystemPickerOptions.defaultPermissionText,
    FileTileSelectMode fileTileSelectMode = FilesystemPickerOptions.defaultFileTileSelectMode,
    bool showGoUp = FilesystemPickerOptions.defaultShowGoUp,
    FilesystemPickerDialogOptions dialog = FilesystemPickerOptions.defaultDialogOptions,
    FilesystemPickerBottomSheetOptions bottomSheet = FilesystemPickerOptions.defaultBottomSheetOptions,
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
  State<FilesystemPickerDefaultOptions> createState() => FilesystemPickerDefaultOptionsState();

  @deprecated
  static FilesystemPickerDefaultOptionsState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FilesystemPickerOptionsScope>()?.options;

  static FilesystemPickerOptions of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<_FilesystemPickerOptionsScope>()?.options.defaultOptions.options ??
          FilesystemPickerOptions._defaultOptions(context));
}

class FilesystemPickerDefaultOptionsState extends State<FilesystemPickerDefaultOptions> {
  FilesystemPickerDefaultOptions get defaultOptions => widget;

  @override
  Widget build(BuildContext context) {
    assert(Navigator.maybeOf(context) == null, /* TODO: */ 'TODO: Must be above navigator.');

    return _FilesystemPickerOptionsScope(
      options: this,
      child: widget.child,
    );
  }
}

class _FilesystemPickerOptionsScope extends InheritedWidget {
  final FilesystemPickerDefaultOptionsState options;

  _FilesystemPickerOptionsScope({
    Key? key,
    required this.options,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant _FilesystemPickerOptionsScope oldWidget) =>
      oldWidget.options.defaultOptions.options != options.defaultOptions.options;
}
