import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShakeableController with ChangeNotifier {
  void shake() {
    notifyListeners();
  }
}

class ShakeableAnimation extends StatefulWidget {
  final ShakeableController controller;
  final Widget child;
  final Curve curve;
  final Duration duration;
  final double distance;
  final int count;

  const ShakeableAnimation({
    Key? key,
    required this.controller,
    required this.child,
    this.curve = Curves.bounceOut,
    this.duration = const Duration(milliseconds: 100),
    this.distance = 12.0,
    this.count = 2,
  }) : super(key: key);

  @override
  State<ShakeableAnimation> createState() => _ShakeableAnimationState();
}

class _ShakeableAnimationState extends State<ShakeableAnimation>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_doShake);
  }

  @override
  void didUpdateWidget(covariant ShakeableAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_doShake);
      widget.controller.addListener(_doShake);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_doShake);

    _controller.dispose();
    super.dispose();
  }

  Future<void> _doShake() async {
    for (var i = 0; i < widget.count; i++) {
      await _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final dx = math.sin(_controller.value * 2 * math.pi) * widget.distance;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
