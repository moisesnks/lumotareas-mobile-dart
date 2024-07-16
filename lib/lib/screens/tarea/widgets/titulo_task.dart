import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';

class TituloTask extends StatelessWidget {
  final TareaFirestore tarea;

  const TituloTask({
    super.key,
    required this.tarea,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tarea.name,
              style: const TextStyle(fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8.0),
          Chip(
            avatar: Icon(
              tarea.private ? Icons.lock : Icons.public,
              color: Colors.white,
            ),
            label: Text(
              tarea.private ? 'Privado' : 'Público',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: tarea.private ? Colors.red : Colors.green,
          ),
        ],
      ),
    );
  }
}
