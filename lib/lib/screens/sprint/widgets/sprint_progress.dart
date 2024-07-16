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
    final String texto =
        '${porcentajeCompletado.toStringAsFixed(1)}% completado';

    return Column(
      children: [
        ProgressBar(
          porcentajeCompletado: porcentajeCompletado,
          esCircular: true,
        ),
        const SizedBox(width: 8),
        Text(texto),
      ],
    );
  }
}
