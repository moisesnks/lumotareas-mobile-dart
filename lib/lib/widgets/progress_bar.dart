import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double porcentajeCompletado;
  final bool
      esCircular; // Nuevo parámetro para determinar si es circular o lineal
  final bool
      textoArriba; // Nuevo parámetro para determinar la posición del texto

  const ProgressBar({
    super.key,
    required this.porcentajeCompletado,
    this.esCircular = false, // Por defecto, es una barra de progreso lineal
    this.textoArriba = false, // Por defecto, el texto está abajo
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: textoArriba
            ? [
                const SizedBox(height: 8),
                _buildProgressIndicator(),
              ]
            : [
                _buildProgressIndicator(),
                const SizedBox(height: 8),
              ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return esCircular
        ? CircularProgressIndicator(
            value: porcentajeCompletado / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        : LinearProgressIndicator(
            value: porcentajeCompletado / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          );
  }
}
