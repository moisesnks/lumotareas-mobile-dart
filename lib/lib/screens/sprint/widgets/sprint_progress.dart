import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/widgets/progress_bar.dart';

class SprintProgress extends StatelessWidget {
  final Sprint sprint;

  const SprintProgress({
    super.key,
    required this.sprint,
  });

  @override
  Widget build(BuildContext context) {
    // Aquí puedes calcular el porcentaje de completado del sprint
    final double porcentajeCompletado = sprint.progress * 100;
    final String texto = porcentajeCompletado == 100
        ? 'Completado'
        : porcentajeCompletado == 0
            ? 'No iniciado'
            : 'En progreso';
    final Color color = porcentajeCompletado == 100
        ? Colors.green
        : porcentajeCompletado == 0
            ? Colors.red
            : Colors.orange;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressBar(
          porcentajeCompletado: porcentajeCompletado,
          esCircular: true,
          mostrarTexto: true,
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
