import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final AnimationType type;

  FadeAnimation(this.delay, this.child,
      {this.type = AnimationType.topToBottom});

  @override
  Widget build(BuildContext context) {
    MultiTrackTween tween;
    if (this.type == AnimationType.topToBottom) {
      tween = MultiTrackTween([
        Track("opacity")
            .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
        Track("translateX").add(
            Duration(milliseconds: 500), Tween(begin: 0.0, end: 0.0),
            curve: Curves.easeOut),
        Track("translateY").add(
            Duration(milliseconds: 500), Tween(begin: -130.0, end: 0.0),
            curve: Curves.easeOut)
      ]);
    } else if (this.type == AnimationType.bottomToTop) {
      tween = MultiTrackTween([
        Track("opacity")
            .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
        Track("translateX").add(
            Duration(milliseconds: 500), Tween(begin: 0.0, end: 0.0),
            curve: Curves.easeOut),
        Track("translateY").add(
            Duration(milliseconds: 500), Tween(begin: 130.0, end: 0.0),
            curve: Curves.easeOut)
      ]);
    } else if (this.type == AnimationType.leftToRight) {
      tween = MultiTrackTween([
        Track("opacity")
            .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
        Track("translateX").add(
            Duration(milliseconds: 500), Tween(begin: -110.0, end: 0.0),
            curve: Curves.easeOut),
        Track("translateY").add(
            Duration(milliseconds: 500), Tween(begin: 0.0, end: 0.0),
            curve: Curves.easeOut)
      ]);
    } else {
      tween = MultiTrackTween([
        Track("opacity")
            .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
        Track("translateX").add(
            Duration(milliseconds: 500), Tween(begin: 110.0, end: 0.0),
            curve: Curves.easeOut),
        Track("translateY").add(
            Duration(milliseconds: 500), Tween(begin: 0.0, end: 0.0),
            curve: Curves.easeOut)
      ]);
    }

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], animation["translateY"]),
            child: child),
      ),
    );
  }
}
