//Widget genérico que muestra una lista de ítems utilizando un constructor de ítems personalizado.
library;

import 'package:flutter/material.dart';

/// Un widget que envuelve a sus hijos en un [Wrap] dentro de un [Container] con color y espaciado personalizados.
class FlexibleWrap extends StatelessWidget {
  final Color color; // El color de fondo del contenedor
  final double spacing; // El espaciado entre los hijos del Wrap
  final List<Widget>
      children; // Los widgets hijos que serán envueltos en el Wrap

  /// Constructor para crear una instancia de [FlexibleWrap].
  ///
  /// [color] es el color de fondo del contenedor.
  /// [spacing] es el espaciado entre los hijos del Wrap.
  /// [children] es la lista de widgets hijos que serán envueltos en el Wrap.
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
