import 'package:flutter/material.dart';

class BoxLabel extends StatelessWidget {
  final Widget child;
  final String labelText;
  final Color fontColor;
  final Color borderColor;
  final Color labelBackgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const BoxLabel({
    super.key,
    required this.child,
    required this.labelText,
    this.borderColor = const Color.fromARGB(255, 100, 102, 168),
    this.labelBackgroundColor = const Color.fromARGB(255, 7, 8, 29),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(0),
    this.fontColor = const Color.fromARGB(255, 100, 102, 168),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
          Positioned(
            left: 16,
            top: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: labelBackgroundColor,
              child: Text(
                labelText,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
