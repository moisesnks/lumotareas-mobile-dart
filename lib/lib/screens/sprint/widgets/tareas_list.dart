import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/tarea/tarea_screen.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class TareasList extends StatelessWidget {
  final List<TareaFirestore> tareas;
  final Usuario currentUser;

  const TareasList({
    super.key,
    required this.tareas,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        final tarea = tareas[index];
        final int doneSubtareas =
            tarea.subtareas.where((subtarea) => subtarea.done).length;
        final int totalSubtareas = tarea.subtareas.length;

        // Calcula el estado de la tarea basado en la fecha de finalización
        String status;
        Color statusColor;

        final DateTime endDate = tarea.endDate.toDate();
        if (doneSubtareas == totalSubtareas) {
          status = 'Completada';
          statusColor = Colors.green;
        } else {
          if (DateTime.now().isBefore(endDate)) {
            status = 'En progreso';
            statusColor = Colors.orange;
          } else {
            status = 'Atrasada';
            statusColor = Colors.red;
          }
        }

        return StyledListTile(
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TareaScreen(
                  tarea: tarea,
                  currentUser: currentUser,
                ),
              ),
            );
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tarea.name),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tarea.description),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.data_usage, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        '$doneSubtareas de $totalSubtareas ${doneSubtareas == 1 ? 'tarea' : 'tareas'}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        '${tarea.asignados.length} ${tarea.asignados.length > 1 ? 'asignados' : 'asignado'}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.comment, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        '${tarea.comentarios.length} ${tarea.comentarios.length > 1 ? 'comentarios' : 'comentario'}',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
