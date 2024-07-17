/// @nodoc
library;

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
    final String texto = porcentaje == 100
        ? 'Completada'
        : porcentaje == 0
            ? 'No iniciada'
            : 'En progreso';
    final Color color = porcentaje == 100
        ? Colors.green
        : porcentaje == 0
            ? Colors.red
            : Colors.orange;

    return Row(
      children: [
        ProgressBar(
          porcentajeCompletado: porcentaje,
          esCircular: true,
          mostrarTexto: true,
        ),
        const SizedBox(width: 8),
        Text(texto,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: color,
            )),
      ],
    );
  }
}
