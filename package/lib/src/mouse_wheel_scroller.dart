import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

typedef MouseWheelScrollerBuilder = Widget Function(
    BuildContext context, ScrollController controller);

class MouseWheelScroller extends StatefulWidget {
  final MouseWheelScrollerBuilder builder;
  final ScrollController? scrollController;

  const MouseWheelScroller({
    super.key,
    required this.builder,
    this.scrollController,
  });

  @override
  State<MouseWheelScroller> createState() => _MouseWheelScrollerState();
}

class _MouseWheelScrollerState extends State<MouseWheelScroller> {
  ScrollController? _scrollController;
  ScrollController get scrollController =>
      widget.scrollController ?? (_scrollController ??= ScrollController());

  final double scrollAmountMultiplier = 3.0;
  final scrollDuration = const Duration(milliseconds: 400);
  final scrollCurve = Curves.linearToEaseOut;
  final int mouseWheelTurnsThrottleTimeMs = 80;

  late final Throttler mouseWheelForwardThrottler;
  late final Throttler mouseWheelBackwardThrottler;

  @override
  void initState() {
    super.initState();
    mouseWheelForwardThrottler = Throttler(mouseWheelTurnsThrottleTimeMs);
    mouseWheelBackwardThrottler = Throttler(mouseWheelTurnsThrottleTimeMs);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, scrollController);

    final isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
    if (isMobile) return child;

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent &&
            event.kind == PointerDeviceKind.mouse) {
          final scrollDelta = event.scrollDelta.dy;

          final newOffset =
              scrollController.offset + scrollDelta * scrollAmountMultiplier;

          final duration = scrollDuration;
          final curve = scrollCurve;

          if (scrollDelta.isNegative) {
            mouseWheelForwardThrottler.run(() {
              scrollController.animateTo(
                math.max(0.0, newOffset),
                duration: duration,
                curve: curve,
              );
            });
          } else {
            mouseWheelBackwardThrottler.run(() {
              scrollController.animateTo(
                math.min(scrollController.position.maxScrollExtent, newOffset),
                duration: duration,
                curve: curve,
              );
            });
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// Throttle some action by a specified amount of milliseconds
class Throttler {
  /// Throttle value
  Throttler(this._throttleTimeMs);

  final int _throttleTimeMs;
  int? _lastRunTimeMs;

  /// Run the function which needs to be throttled
  void run(void Function() action) {
    if (_lastRunTimeMs == null) {
      action();
      _lastRunTimeMs = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - _lastRunTimeMs! >
          _throttleTimeMs) {
        action();
        _lastRunTimeMs = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}
