import 'package:flutter/material.dart';
class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final bool iconLike;
  final VoidCallback? End;
  final Duration duration;

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.End,
    this.iconLike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds :widget.duration.inMilliseconds ~/2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating || oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.iconLike) {
      await controller.forward();
      await controller.reverse();

      await Future.delayed(
        Duration(milliseconds: 200),
      );
    }
    if (widget.End != null) {
      widget.End!();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: scale,
        child: widget.child,
    );
  }
}
