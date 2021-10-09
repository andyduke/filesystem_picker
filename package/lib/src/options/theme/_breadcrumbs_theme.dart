import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class BreadcrumbsThemeData with Diagnosticable {
  static const defaultSeparatorIcon = Icons.chevron_right;
  static const double defaultSeparatorIconSize = 24;
  static const double defaultLeadingSpacing = 8;
  static const double defaultTrailingSpacing = 70;
  static const MaterialTapTargetSize defaultItemTapTargetSize = MaterialTapTargetSize.padded;

  final Color? itemColor;
  final Color? inactiveItemColor;
  final EdgeInsetsGeometry? itemPadding;
  final Size? itemMinimumSize;
  final MaterialTapTargetSize? itemTapTargetSize;
  final Color? overlayColor;
  final IconData? separatorIcon;
  final double? separatorIconSize;
  final Color? separatorColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? leadingSpacing;
  final double? trailingSpacing;

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

  Color getItemColor(BuildContext context, [Color? color]) {
    final effectiveItemColor = color ?? itemColor ?? Theme.of(context).textTheme.button!.color;
    return effectiveItemColor!;
  }

  Color getInactiveItemColor(BuildContext context, [Color? color]) {
    return inactiveItemColor ?? (color ?? getItemColor(context, color)).withOpacity(0.75);
  }

  Color getSeparatorColor(BuildContext context, [Color? color]) {
    return separatorColor ?? (color ?? getItemColor(context, color)).withOpacity(0.45);
  }

  MaterialTapTargetSize getItemTapTargetSize(BuildContext context) {
    return itemTapTargetSize ?? defaultItemTapTargetSize;
  }

  Color getOverlayColor(BuildContext context, [Color? color]) {
    return overlayColor ?? (color ?? getItemColor(context, color)).withOpacity(0.12);
  }

  IconData getSeparatorIcon(BuildContext context) {
    return separatorIcon ?? Icons.chevron_right;
  }

  double getSeparatorIconSize(BuildContext context) {
    return separatorIconSize ?? defaultSeparatorIconSize;
  }

  TextStyle getTextStyle(BuildContext context) {
    return textStyle ?? AppBarTheme.of(context).toolbarTextStyle ?? TextStyle();
  }

  double getLeadingSpacing(BuildContext context) {
    return leadingSpacing ?? defaultLeadingSpacing;
  }

  double getTrailingSpacing(BuildContext context) {
    return trailingSpacing ?? defaultTrailingSpacing;
  }

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
