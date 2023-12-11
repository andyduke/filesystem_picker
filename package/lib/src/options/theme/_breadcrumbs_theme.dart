import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines a theme for the breadcrumbs used in the picker and [Breadcrumbs] widget.
///
/// Here you can set the color and style of the items, icons and their size, etc.
@immutable
class BreadcrumbsThemeData with Diagnosticable {
  /// The default separator icon.
  static const defaultSeparatorIcon = Icons.chevron_right;

  /// The default size for the separator icon.
  static const double defaultSeparatorIconSize = 24;

  /// Leading spacing by default.
  static const double defaultLeadingSpacing = 8;

  /// Trailing spacing by default.
  static const double defaultTrailingSpacing = 70;

  /// The default minimum size of the area within which the button may be pressed.
  static const MaterialTapTargetSize defaultItemTapTargetSize =
      MaterialTapTargetSize.padded;

  /// The color of the last (active) item.
  final Color? itemColor;

  /// The color of the inactive item.
  final Color? inactiveItemColor;

  /// The padding between the item's boundary and its content.
  final EdgeInsetsGeometry? itemPadding;

  /// The minimum size of the item itself.
  final Size? itemMinimumSize;

  /// Configures the minimum size of the area within which the item may be pressed.
  ///
  /// If the [tapTargetSize] is larger than [minimumSize], the item will include
  /// a transparent margin that responds to taps.
  final MaterialTapTargetSize? itemTapTargetSize;

  /// The highlight color that's typically used to indicate that
  /// the item is focused, hovered, or pressed.
  final Color? overlayColor;

  /// The separator icon that is placed between the breadcrumb items.
  final IconData? separatorIcon;

  /// The size of the [separatorIcon].
  final double? separatorIconSize;

  /// The color of the [separatorIcon].
  final Color? separatorColor;

  /// The background fill color under the breadcrumbs.
  final Color? backgroundColor;

  /// The text style for the items of the breadcrumbs.
  final TextStyle? textStyle;

  /// Leading spacing before breadcrumbs.
  final double? leadingSpacing;

  /// Trailing spacing after breadcrumbs.
  final double? trailingSpacing;

  /// Creates a theme that can be used in [FilesystemPickerTopBarThemeData] and [Breadcrumbs].
  BreadcrumbsThemeData({
    this.itemColor,
    this.inactiveItemColor,
    this.itemPadding,
    this.itemMinimumSize,
    this.itemTapTargetSize,
    this.overlayColor,
    this.separatorIcon,
    this.separatorIconSize,
    this.separatorColor,
    this.backgroundColor,
    this.textStyle,
    this.leadingSpacing,
    this.trailingSpacing,
  });

  /// Returns the text color of the breadcrumbs item.
  ///
  /// If no value is set in the theme, the color of the [textTheme] button is returned
  /// (the app theme is taken from the `context`).
  Color getItemColor(BuildContext context, [Color? color]) {
    final effectiveItemColor = color ??
        itemColor ??
        Theme.of(context).textTheme.labelLarge?.color ??
        const Color(0xFF000000);
    return effectiveItemColor;
  }

  /// Returns the text color of the inactive breadcrumbs item.
  ///
  /// If no value is set in the theme, the color of the item is returned with opacity 0.75
  /// (the app theme is taken from the `context`).
  Color getInactiveItemColor(BuildContext context, [Color? color]) {
    return inactiveItemColor ??
        (color ?? getItemColor(context, color)).withOpacity(0.75);
  }

  /// Returns the color of the [separatorIcon].
  ///
  /// If no value is set in the theme, the color of the item is returned with opacity 0.45
  /// (the app theme is taken from the `context`).
  Color getSeparatorColor(BuildContext context, [Color? color]) {
    return separatorColor ??
        (color ?? getItemColor(context, color)).withOpacity(0.45);
  }

  /// Returns the minimum size of the area within which the item may be pressed.
  MaterialTapTargetSize getItemTapTargetSize(BuildContext context) {
    return itemTapTargetSize ?? defaultItemTapTargetSize;
  }

  /// Returns the highlight color that's typically used to indicate that
  /// the item is focused, hovered, or pressed.
  ///
  /// If no value is set in the theme, the color of the item is returned with opacity 0.12
  /// (the app theme is taken from the `context`).
  Color getOverlayColor(BuildContext context, [Color? color]) {
    return overlayColor ??
        (color ?? getItemColor(context, color)).withOpacity(0.12);
  }

  /// Returns the separator icon that is placed between the breadcrumb items.
  ///
  /// If no value is set in the theme, the [Icons.chevron_right] icon is returned.
  IconData getSeparatorIcon(BuildContext context) {
    return separatorIcon ?? Icons.chevron_right;
  }

  /// Returns the size of the [separatorIcon].
  double getSeparatorIconSize(BuildContext context) {
    return separatorIconSize ?? defaultSeparatorIconSize;
  }

  /// Returns the text style for the items of the breadcrumbs.
  ///
  /// If no value is set in the theme, the [toolbarTextStyle] of the [AppBarTheme] is returned
  /// (the app theme is taken from the `context`).
  TextStyle getTextStyle(BuildContext context) {
    return textStyle ??
        AppBarTheme.of(context).toolbarTextStyle ??
        const TextStyle();
  }

  /// Returns the leading spacing before breadcrumbs.
  double getLeadingSpacing(BuildContext context) {
    return leadingSpacing ?? defaultLeadingSpacing;
  }

  /// Returns the trailing spacing after breadcrumbs.
  double getTrailingSpacing(BuildContext context) {
    return trailingSpacing ?? defaultTrailingSpacing;
  }

  /// Returns a new breadcrumbs theme that matches this theme but with some values
  /// replaced by the non-null parameters of the given theme.
  ///
  /// If the given theme is null, simply returns this theme.
  BreadcrumbsThemeData merge(BreadcrumbsThemeData? base) {
    if (base == null) return this;

    return BreadcrumbsThemeData(
      itemColor: itemColor ?? base.itemColor,
      inactiveItemColor: inactiveItemColor ?? base.inactiveItemColor,
      itemPadding: itemPadding ?? base.itemPadding,
      itemMinimumSize: itemMinimumSize ?? base.itemMinimumSize,
      itemTapTargetSize: itemTapTargetSize ?? base.itemTapTargetSize,
      overlayColor: overlayColor ?? base.overlayColor,
      separatorIcon: separatorIcon ?? base.separatorIcon,
      separatorIconSize: separatorIconSize ?? base.separatorIconSize,
      separatorColor: separatorColor ?? base.separatorColor,
      backgroundColor: backgroundColor ?? base.backgroundColor,
      textStyle: textStyle?.merge(base.textStyle) ?? base.textStyle,
      leadingSpacing: leadingSpacing ?? base.leadingSpacing,
      trailingSpacing: trailingSpacing ?? base.trailingSpacing,
    );
  }
}
