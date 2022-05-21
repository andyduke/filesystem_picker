import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FilesystemPickerDialogOptions with Diagnosticable {
  static const BoxConstraints defaultConstraints = BoxConstraints(
    minWidth: 280,
    minHeight: 460,
    maxWidth: 690,
    maxHeight: 690,
  );

  final BoxConstraints constraints;

  const FilesystemPickerDialogOptions({
    this.constraints = defaultConstraints,
  });

  @override
  int get hashCode {
    return constraints.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerDialogOptions &&
        other.constraints == constraints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: defaultConstraints));
  }
}
