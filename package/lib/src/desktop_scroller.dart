import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'mouse_wheel_scroller.dart';

typedef DesktopScrollerBuilder = Widget Function(
    BuildContext context, ScrollController controller);

class DesktopScroller extends StatefulWidget {
  final DesktopScrollerBuilder builder;
  final ScrollController? scrollController;

  const DesktopScroller({
    super.key,
    required this.builder,
    this.scrollController,
  });

  @override
  State<DesktopScroller> createState() => _DesktopScrollerState();
}

class _DesktopScrollerState extends State<DesktopScroller> {
  ScrollController? _scrollController;
  ScrollController get scrollController =>
      widget.scrollController ?? (_scrollController ??= ScrollController());

  @override
  Widget build(BuildContext context) {
    final isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
    if (isMobile) return widget.builder(context, scrollController);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      }),
      child: MouseWheelScroller(
        scrollController: scrollController,
        builder: (context, controller) {
          return widget.builder(context, controller);
        },
      ),
    );
  }
}
