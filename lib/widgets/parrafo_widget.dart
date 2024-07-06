import 'package:flutter/material.dart';

class Parrafo extends StatelessWidget {
  final String texto;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final Color color;
  final List<String> boldTexts; // Textos a resaltar en negrita
  final List<String> underlinedTexts; // Textos a subrayar
  final int maxLines; // Número máximo de líneas a mostrar

  const Parrafo({
    super.key,
    required this.texto,
    this.fontSize = 12.0,
    this.fontFamily = 'Manrope',
    this.fontWeight = FontWeight.w300,
    this.color = Colors.white,
    this.boldTexts = const [],
    this.underlinedTexts = const [],
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    // Función para crear un TextSpan con estilo
    TextSpan createTextSpan(
        String text, FontWeight fontWeight, TextDecoration? decoration) {
      return TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
        ),
      );
    }

    // Divide el texto en partes para resaltar y subrayar
    List<TextSpan> spans = [];
    String tempText = texto;

    List<String> tempBoldTexts = [...boldTexts];
    List<String> tempUnderlinedTexts = [...underlinedTexts];

    while (tempText.isNotEmpty && spans.length < maxLines) {
      // Encuentra la primera ocurrencia de un texto a resaltar o subrayar
      int boldIndex =
          tempBoldTexts.isEmpty ? -1 : tempText.indexOf(tempBoldTexts.first);
      int underlineIndex = tempUnderlinedTexts.isEmpty
          ? -1
          : tempText.indexOf(tempUnderlinedTexts.first);

      // Encuentra el índice más bajo de cualquiera de los dos
      int nextIndex = (boldIndex >= 0 &&
              (underlineIndex == -1 || boldIndex < underlineIndex))
          ? boldIndex
          : underlineIndex;

      // Si no hay más ocurrencias, agrega el texto restante
      if (nextIndex == -1) {
        spans.add(createTextSpan(tempText, fontWeight, null));
        break;
      }

      // Si hay texto antes del próximo estilo, agréguelo como normal
      if (nextIndex > 0) {
        spans.add(
            createTextSpan(tempText.substring(0, nextIndex), fontWeight, null));
        tempText = tempText.substring(nextIndex);
      }

      // Agrega el próximo texto con el estilo correspondiente
      if (nextIndex == boldIndex) {
        String boldText = tempBoldTexts.first;
        spans.add(createTextSpan(boldText, FontWeight.bold, null));
        tempText = tempText.substring(boldText.length);
        tempBoldTexts = tempBoldTexts.sublist(1);
      } else {
        String underlinedText = tempUnderlinedTexts.first;
        spans.add(createTextSpan(
            underlinedText, fontWeight, TextDecoration.underline));
        tempText = tempText.substring(underlinedText.length);
        tempUnderlinedTexts = tempUnderlinedTexts.sublist(1);
      }
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
