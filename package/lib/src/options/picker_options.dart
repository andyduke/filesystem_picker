import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common.dart';
import 'theme/theme.dart';
import 'theme/theme_base.dart';

class FilesystemPickerOptions with Diagnosticable {
  static const String defaultRootName = 'Storage';
  static const FilesystemType defaultFsType = FilesystemType.all;
  static const String defaultPermissionText = 'Access to the storage was not granted.';
  static const FileTileSelectMode defaultFileTileSelectMode = FileTileSelectMode.checkButton;
  static const bool defaultShowGoUpItem = true;

  final FilesystemPickerThemeBase? _theme;
  final String rootName;
  final FilesystemType fsType;
  final String permissionText;
  final FileTileSelectMode fileTileSelectMode;
  final bool showGoUpItem;

  FilesystemPickerOptions({
    FilesystemPickerThemeBase? theme,
    this.rootName = defaultRootName,
    this.fsType = defaultFsType,
    this.permissionText = defaultPermissionText,
    this.fileTileSelectMode = defaultFileTileSelectMode,
    this.showGoUpItem = defaultShowGoUpItem,
  }) : _theme = theme;

  static FilesystemPickerOptions _defaultOptions(BuildContext context) {
    return FilesystemPickerOptions();
  }

  FilesystemPickerThemeBase get theme => _theme ?? FilesystemPickerTheme.light();

  /*
  FilesystemPickerOptions data(BuildContext context) {
    late FilesystemPickerThemeBase effectiveTheme = theme ?? FilesystemPickerTheme.light();

    return FilesystemPickerOptions(
      theme: effectiveTheme,
      rootName: rootName,
      fsType: fsType,
      permissionText: permissionText,
      fileTileSelectMode: fileTileSelectMode,
      showGoUpItem: showGoUpItem,
    );
  }
  */

  @override
  int get hashCode {
    return hashValues(
      theme,
      rootName,
      fsType,
      permissionText,
      fileTileSelectMode,
      showGoUpItem,
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
        other.showGoUpItem == showGoUpItem;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerThemeBase>('theme', theme, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('rootName', rootName, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemType>('fsType', fsType, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('permissionText', permissionText, defaultValue: null));
    properties
        .add(DiagnosticsProperty<FileTileSelectMode>('fileTileSelectMode', fileTileSelectMode, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('showGoUpItem', showGoUpItem, defaultValue: null));
  }
}

/*
class FilesystemPickerOptions with Diagnosticable /*extends FilesystemPickerOptionsData*/ {
  final FilesystemPickerThemeBase? theme;
  final FilesystemPickerThemeBase? darkTheme;
  final ThemeMode? themeMode;
  // final FilesystemPickerOptionsData data;

  final String rootName;
  final FilesystemType fsType;
  final String permissionText;
  final FileTileSelectMode fileTileSelectMode;
  final bool showGoUpItem;

  FilesystemPickerOptions({
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,

    //
    this.rootName = FilesystemPickerOptionsData.defaultRootName,
    this.fsType = FilesystemPickerOptionsData.defaultFsType,
    this.permissionText = FilesystemPickerOptionsData.defaultPermissionText,
    this.fileTileSelectMode = FilesystemPickerOptionsData.defaultFileTileSelectMode,
    this.showGoUpItem = FilesystemPickerOptionsData.defaultShowGoUpItem,

    /*
    String rootName = FilesystemPickerOptionsData.defaultRootName,
    FilesystemType fsType = FilesystemPickerOptionsData.defaultFsType,
    String permissionText = FilesystemPickerOptionsData.defaultPermissionText,
    FileTileSelectMode fileTileSelectMode = FilesystemPickerOptionsData.defaultFileTileSelectMode,
    */
  }) /*: data = FilesystemPickerOptionsData(
          rootName: rootName,
          fsType: fsType,
          permissionText: permissionText,
          fileTileSelectMode: fileTileSelectMode,
        )*/
  ;

  static FilesystemPickerOptions _defaultOptions(BuildContext context) {
    return FilesystemPickerOptions();
  }

  FilesystemPickerOptionsData data(BuildContext context) {
    late FilesystemPickerThemeBase effectiveTheme;

    switch (themeMode) {
      case ThemeMode.light:
        effectiveTheme = theme ?? FilesystemPickerTheme.light();
        break;

      case ThemeMode.dark:
        effectiveTheme = darkTheme ?? FilesystemPickerTheme.dark();
        break;

      case ThemeMode.system:
      default:
        effectiveTheme = (Theme.of(context).brightness == Brightness.light)
            ? (theme ?? FilesystemPickerTheme.light())
            : (darkTheme ?? FilesystemPickerTheme.dark());
        break;
    }

    return FilesystemPickerOptionsData(
      theme: effectiveTheme,
      rootName: rootName,
      fsType: fsType,
      permissionText: permissionText,
      fileTileSelectMode: fileTileSelectMode,
      showGoUpItem: showGoUpItem,
    );
  }

  @override
  int get hashCode {
    /*
    return super.hashCode ^
        hashValues(
          darkTheme,
          themeMode,
        );
    */
    return hashValues(
      theme,
      darkTheme,
      themeMode,
      // data,

      rootName,
      fsType,
      permissionText,
      fileTileSelectMode,
    );
  }

  @override
  bool operator ==(Object other) {
    /*
    return super == (other) &&
        other is FilesystemPickerOptions &&
        other.darkTheme == darkTheme &&
        other.themeMode == themeMode;
    */

    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerOptions &&
        other.theme == theme &&
        other.darkTheme == darkTheme &&
        other.themeMode == themeMode &&
        // other.data == data;

        other.rootName == rootName &&
        other.fsType == fsType &&
        other.permissionText == permissionText &&
        other.fileTileSelectMode == fileTileSelectMode;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    /*
    properties.add(DiagnosticsProperty<ThemeMode>('themeMode', themeMode, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerTheme>('darkTheme', darkTheme, defaultValue: null));
    super.debugFillProperties(properties);
    */

    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ThemeMode>('themeMode', themeMode, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerThemeBase>('theme', theme, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemPickerThemeBase>('darkTheme', darkTheme, defaultValue: null));
    // properties.add(DiagnosticsProperty<FilesystemPickerOptionsData>('data', data, defaultValue: null));

    properties.add(DiagnosticsProperty<String>('rootName', rootName, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemType>('fsType', fsType, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('permissionText', permissionText, defaultValue: null));
    properties
        .add(DiagnosticsProperty<FileTileSelectMode>('fileTileSelectMode', fileTileSelectMode, defaultValue: null));
  }
}
*/

/*
@immutable
class FilesystemPickerOptions with Diagnosticable {
  final FilesystemPickerTheme? theme;
  // final FilesystemPickerTheme? darkTheme;
  // final ThemeMode? themeMode;
  final String rootName;
  final FilesystemType fsType;
  final String permissionText;
  final FileTileSelectMode fileTileSelectMode;

  // FilesystemPickerTheme effectiveTheme(Brightness brightness) {}

  FilesystemPickerOptionsData data(BuildContext context) {
    // TODO:
  }

  FilesystemPickerOptions({
    this.theme,
    this.rootName = defaultRootName,
    this.fsType = defaultFsType,
    this.permissionText = defaultPermissionText,
    this.fileTileSelectMode = defaultFileTileSelectMode,
  });

  static FilesystemPickerOptions _defaultOptions(BuildContext context) {
    return FilesystemPickerOptions();
  }

  @override
  int get hashCode {
    return hashValues(
      theme,
      rootName,
      fsType,
      permissionText,
      fileTileSelectMode,
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
        other.fileTileSelectMode == fileTileSelectMode;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FilesystemPickerTheme>('theme', theme, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('rootName', rootName, defaultValue: null));
    properties.add(DiagnosticsProperty<FilesystemType>('fsType', fsType, defaultValue: null));
    properties.add(DiagnosticsProperty<String>('permissionText', permissionText, defaultValue: null));
    properties
        .add(DiagnosticsProperty<FileTileSelectMode>('fileTileSelectMode', fileTileSelectMode, defaultValue: null));
  }
}
*/

class FilesystemPickerDefaultOptions extends StatefulWidget {
  final Widget child;
  final FilesystemPickerOptions options;

  FilesystemPickerDefaultOptions({
    Key? key,
    required this.child,
    required this.options,
  }) : super(
          key: key,
        );

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

  /*
  @deprecated
  // FilesystemPickerTheme get theme => widget.theme ?? FilesystemPickerTheme();
  FilesystemPickerThemeBase get theme {
    debugPrint('* ${Theme.of(context)}');
    return widget.options.theme ?? FilesystemPickerTheme.light();
  }
  */

  @override
  Widget build(BuildContext context) {
    assert(Navigator.maybeOf(context) == null, 'TODO: Must be above navigator.');

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

/*
class FilesystemPickerOptions extends InheritedWidget {
  static const String defaultRootName = 'Storage';
  static const FilesystemType defaultFsType = FilesystemType.all;
  static const FileTileSelectMode defaultFileTileSelectMode = FileTileSelectMode.checkButton;

  final FilesystemPickerTheme? theme;
  final String rootName;
  final FilesystemType fsType;
  final String? permissionText;
  final Color? folderIconColor;
  final FileTileSelectMode fileTileSelectMode;

  FilesystemPickerOptions({
    Key? key,
    required Widget child,
    this.theme,
    this.rootName = defaultRootName,
    this.fsType = defaultFsType,
    this.permissionText,
    this.folderIconColor,
    this.fileTileSelectMode = defaultFileTileSelectMode,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant FilesystemPickerOptions oldWidget) {
    return (oldWidget.rootName != rootName) ||
        (oldWidget.fsType != fsType) ||
        (oldWidget.permissionText != permissionText) ||
        (oldWidget.folderIconColor != folderIconColor) ||
        (oldWidget.fileTileSelectMode != fileTileSelectMode);
  }

  static FilesystemPickerOptions? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FilesystemPickerOptions>();
}
*/
