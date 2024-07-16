import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double porcentajeCompletado;
  final bool esCircular;
  final bool mostrarTexto;

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
