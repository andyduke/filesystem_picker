import 'package:flutter/material.dart';
import 'listview_extensions.dart';
import 'options/theme/_breadcrumbs_theme.dart';

/// Path element description class for breadcrumbs
class BreadcrumbItem<T> {
  /// Item text
  final String text;

  /// Item related data
  final T? data;

  /// Called when an item is selected
  final ValueChanged<T>? onSelect;

  /// Creates an item of breadcrumbs
  BreadcrumbItem({
    required this.text,
    this.data,
    this.onSelect,
  });
}

/// Horizontally scrollable breadcrumbs with `Icons.chevron_right` separator and fade on the right.
class Breadcrumbs<T> extends StatelessWidget {
  static const double defaultHeight = 50;

  /// List of items of breadcrumbs
  final List<BreadcrumbItem<T?>> items;

  /// Height of the breadcrumbs panel
  final double height;

  /// List item text color
  final Color? textColor;

  /// Called when an item is selected
  final ValueChanged<T?>? onSelect;

  /// The theme for Breadcrumbs.
  final BreadcrumbsThemeData? theme;

  final ScrollController _scrollController = ScrollController();

  /// Creates horizontally scrollable breadcrumbs with `Icons.chevron_right` separator and fade on the right.
  Breadcrumbs({
    Key? key,
    required this.items,
    this.height = defaultHeight,
    this.textColor,
    this.onSelect,
    this.theme,
  }) : super(key: key);

  _scrollToEnd() async {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    final effectiveTheme = theme ?? BreadcrumbsThemeData();
    final textStyle = effectiveTheme.getTextStyle(context);
    final activeColor = effectiveTheme.getItemColor(context, textColor);
    final inactiveColor = effectiveTheme.getInactiveItemColor(context, textColor);
    final separatorColor = effectiveTheme.getSeparatorColor(context, textColor);
    final overlayColor = effectiveTheme.getOverlayColor(context, textColor);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveTheme.backgroundColor,
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment(0.7, 0.5),
            end: Alignment.centerRight,
            colors: <Color>[Colors.white, Colors.transparent],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Container(
          alignment: Alignment.topLeft,
          height: height,
          child: ListViewExtended.separatedWithHeaderFooter(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final textColor = (index == (items.length - 1)) ? activeColor : inactiveColor;

              return TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(overlayColor),
                  minimumSize: (effectiveTheme.itemMinimumSize != null)
                      ? MaterialStateProperty.all(effectiveTheme.itemMinimumSize)
                      : null,
                  padding: (effectiveTheme.itemPadding != null)
                      ? MaterialStateProperty.all(effectiveTheme.itemPadding)
                      : null,
                  tapTargetSize: effectiveTheme.getItemTapTargetSize(context),
                ),
                child: Text(
                  items[index].text,
                  style: textStyle.copyWith(color: textColor),
                ),
                onPressed: () {
                  items[index].onSelect?.call(items[index].data);
                  onSelect?.call(items[index].data);
                },
              );
            },
            separatorBuilder: (_, __) => Align(
              alignment: Alignment.center,
              child: Icon(
                effectiveTheme.getSeparatorIcon(context),
                color: separatorColor,
                size: effectiveTheme.getSeparatorIconSize(context),
              ),
            ),
            headerBuilder: (_) => SizedBox(width: effectiveTheme.getLeadingSpacing(context)),
            footerBuilder: (_) => SizedBox(width: effectiveTheme.getTrailingSpacing(context)),
          ),
        ),
      ),
    );
  }
}
