import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';

class SubtareaConfirmationDialog extends StatelessWidget {
  final Subtarea subtarea;
  final bool done;
  final void Function() onConfirm;

  const SubtareaConfirmationDialog({
    super.key,
    required this.subtarea,
    required this.done,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: Text(
          '¿Desea marcar esta subtarea como ${done ? 'completada' : 'pendiente'}?'),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm();
          },
          child: const Text('Sí'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
    );
  }
}
