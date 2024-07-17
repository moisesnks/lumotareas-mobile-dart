// Widget que muestra una barra de progreso, ya sea circular o lineal.
library;

import 'package:flutter/material.dart';

/// Un widget que muestra una barra de progreso, ya sea circular o lineal.
class ProgressBar extends StatelessWidget {
  final double porcentajeCompletado; // El porcentaje de progreso completado
  final bool esCircular; // Indica si la barra de progreso es circular
  final bool
      mostrarTexto; // Indica si se debe mostrar el texto del porcentaje completado

  /// Constructor para crear una instancia de [ProgressBar].
  ///
  /// [porcentajeCompletado] es el porcentaje de progreso completado.
  /// [esCircular] indica si la barra de progreso es circular.
  /// [mostrarTexto] indica si se debe mostrar el texto del porcentaje completado.
  const ProgressBar({
    super.key,
    required this.porcentajeCompletado,
    this.esCircular = false,
    this.mostrarTexto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: esCircular
          ? _buildCircularProgressIndicator()
          : _buildLinearProgressIndicator(),
    );
  }

  /// Construye un indicador de progreso circular.
  Widget _buildCircularProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            strokeWidth: 8,
            value: porcentajeCompletado / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        if (mostrarTexto)
          Text(
            '${porcentajeCompletado.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  /// Construye un indicador de progreso lineal.
  Widget _buildLinearProgressIndicator() {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: porcentajeCompletado / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        if (mostrarTexto)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '${porcentajeCompletado.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
