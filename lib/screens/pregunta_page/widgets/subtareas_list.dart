import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/subtarea.dart';

import 'subtarea_widget.dart';

class SubtareasListWidget extends StatelessWidget {
  final List<dynamic> respuestaVisual;
  final Function(Subtarea, int) updateSubtarea;
  final VoidCallback addSubtarea;

  const SubtareasListWidget({
    super.key,
    required this.respuestaVisual,
    required this.updateSubtarea,
    required this.addSubtarea,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < respuestaVisual.length; i++)
            SubtareaWidget(
              subtarea: respuestaVisual[i] as Subtarea,
              onChanged: (subtarea) => updateSubtarea(subtarea, i),
            ),
          TextButton(
            onPressed: addSubtarea,
            child: const Text('Agregar Subtarea'),
          ),
        ],
      ),
    );
  }
}
