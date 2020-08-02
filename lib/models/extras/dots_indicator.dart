import 'dart:math';
import 'package:flutter/material.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
    this.activeColor: Colors.blueAccent,
    this.spacingBetweenDots: 25.0,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  final Color activeColor;

  // The base size of the dots
  static const double dotWidth = 15.0;
  static const double dotHeight = 5.0;

  // The increase in the size of the selected dot
  static const double maxZoom = 2.0;

  // The distance between the center of each dot
  final double spacingBetweenDots;
  static const double widthOfNotSelectedDots = 0.3;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        widthOfNotSelectedDots,
        1.0 -
            ((controller.page ?? controller.initialPage) -
                    index +
                    widthOfNotSelectedDots)
                .abs(),
      ),
    );
    double zoom = 0.1 + (maxZoom - 1.0) * selectedness;
    return new Container(
      width: spacingBetweenDots * zoom,
      child: new Center(
        child: new Container(
          decoration: BoxDecoration(
            color: controller.page == index ? activeColor : color,
            borderRadius: BorderRadius.circular(10),
          ),
          width: dotWidth * zoom,
          height: dotHeight,
          child: new InkWell(
            onTap: () => onPageSelected(index),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
