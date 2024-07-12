import 'package:flutter/material.dart';

class FlexibleWrap extends StatelessWidget {
  final Color color;
  final double spacing;
  final List<Widget> children;

  const FlexibleWrap({
    super.key,
    required this.color,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.all(spacing),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: children.map((child) {
          return Container(
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
