/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/tareas.dart';
import 'package:lumotareas/screens/tarea/widgets/tarea_progress.dart';

class TituloTask extends StatelessWidget {
  final TareaFirestore tarea;
  final Function onTap;
  final String userId;

  const TituloTask({
    super.key,
    required this.tarea,
    required this.onTap,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = tarea.createdBy == userId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tarea.name,
                  style: const TextStyle(fontSize: 20.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
              const SizedBox(width: 8),
              isOwner
                  ? Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {
                          onTap();
                        },
                        child: const Icon(Icons.delete),
                      ),
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          const SizedBox(height: 8),
          TaskProgress(tarea: tarea),
        ],
      ),
    );
  }
}
