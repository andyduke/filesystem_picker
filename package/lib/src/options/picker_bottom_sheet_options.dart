import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class FilesystemPickerBottomSheetOptions with Diagnosticable {
  static const BoxConstraints defaultConstraints = BoxConstraints(
    minWidth: 280,
    maxWidth: 300,
  );
  static const Color defaultBarrierColor = Color(0x00000000);
  static const ShapeBorder defaultShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(8),
    ),
  );
  static const double defaultElevation = 24;

  static const double defaultInitialChildSize = 0.8;
  static const double defaultMinChildSize = 0.6;
  static const double defaultMaxChildSize = 0.96;

  final BoxConstraints constraints;
  final Color barrierColor;
  final ShapeBorder shape;
  final double elevation;

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const FilesystemPickerBottomSheetOptions({
    this.constraints = defaultConstraints,
    this.barrierColor = defaultBarrierColor,
    this.shape = defaultShape,
    this.elevation = defaultElevation,
    this.initialChildSize = defaultInitialChildSize,
    this.minChildSize = defaultMinChildSize,
    this.maxChildSize = defaultMaxChildSize,
  });

  @override
  int get hashCode {
    return Object.hash(
      constraints,
      barrierColor,
      shape,
      elevation,
      initialChildSize,
      minChildSize,
      maxChildSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilesystemPickerBottomSheetOptions &&
        other.constraints == constraints &&
        other.barrierColor == barrierColor &&
        other.shape == shape &&
        other.elevation == elevation &&
        other.initialChildSize == initialChildSize &&
        other.minChildSize == minChildSize &&
        other.maxChildSize == maxChildSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>(
        'constraints', constraints,
        defaultValue: defaultConstraints));
    properties.add(DiagnosticsProperty<Color>('barrierColor', barrierColor,
        defaultValue: defaultBarrierColor));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape,
        defaultValue: defaultShape));
    properties.add(DiagnosticsProperty<double>('elevation', elevation,
        defaultValue: defaultElevation));
    properties.add(DiagnosticsProperty<double>(
        'initialChildSize', initialChildSize,
        defaultValue: defaultInitialChildSize));
    properties.add(DiagnosticsProperty<double>('minChildSize', minChildSize,
        defaultValue: defaultMinChildSize));
    properties.add(DiagnosticsProperty<double>('maxChildSize', maxChildSize,
        defaultValue: defaultMaxChildSize));
  }
}
