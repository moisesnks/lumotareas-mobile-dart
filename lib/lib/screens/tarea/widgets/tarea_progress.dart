import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/widgets/progress_bar.dart';

class TaskProgress extends StatelessWidget {
  final TareaFirestore tarea;

  const TaskProgress({
    super.key,
    required this.tarea,
  });

  @override
  Widget build(BuildContext context) {
    final double porcentaje = tarea.progress * 100;
    final String texto = '${porcentaje.toStringAsFixed(1)}% completado';

    return Row(
      children: [
        ProgressBar(
          porcentajeCompletado: porcentaje,
          esCircular: true,
        ),
        const SizedBox(width: 8),
        Text(texto),
      ],
    );
  }
}
