import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Titulo extends StatelessWidget {
  final String texto;
  final double minFontSize;
  final double maxFontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final Color color;

  const Titulo({
    super.key,
    required this.texto,
    this.minFontSize = 12,
    this.maxFontSize = 24,
    this.fontFamily = 'Lexend',
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      texto,
      style: TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        color: color,
      ),
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      maxLines: 1,
    );
  }
}
