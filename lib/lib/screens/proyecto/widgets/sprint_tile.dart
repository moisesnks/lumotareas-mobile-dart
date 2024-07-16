import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/screens/sprint/widgets/sprint_progress.dart';
import 'package:lumotareas/utils/time.dart';
import 'package:lumotareas/lib/utils/constants.dart';

class SprintTile extends StatelessWidget {
  final Sprint sprint;
  final VoidCallback onTap;
  final int index;

  const SprintTile({
    super.key,
    required this.sprint,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final String startDate =
        Utils.formatTimestamp(sprint.sprintFirestore.startDate);
    final String endDate =
        Utils.formatTimestamp(sprint.sprintFirestore.endDate);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: index.isOdd ? primaryColor : secondaryColor,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sprint.sprintFirestore.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        sprint.sprintFirestore.description,
                        style: const TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SprintProgress(sprint: sprint),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              'Inicio: $startDate',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Fin: $endDate',
              style: const TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                _buildStatusIcon(sprint.status),
                const SizedBox(width: 8.0),
                Text(
                  sprint.status,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Text(
              sprint.quedanDias,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      int.parse(sprint.tareasCompletadas) > 0
                          ? Icons.check_circle
                          : Icons.error,
                      color: int.parse(sprint.tareasCompletadas) > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${sprint.tareasCompletadas} tarea${int.parse(sprint.tareasCompletadas) != 1 ? 's' : ''} completada${int.parse(sprint.tareasCompletadas) != 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      int.parse(sprint.tareasEnProgreso) > 0
                          ? Icons.pending_actions
                          : Icons.error,
                      color: int.parse(sprint.tareasEnProgreso) > 0
                          ? Colors.blue
                          : Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${sprint.tareasEnProgreso} tarea${int.parse(sprint.tareasEnProgreso) != 1 ? 's' : ''} pendiente${int.parse(sprint.tareasEnProgreso) != 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(
                      int.parse(sprint.totalSubtareasCompletadas) > 0
                          ? Icons.check_box
                          : Icons.error,
                      color: int.parse(sprint.totalSubtareasCompletadas) > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '${sprint.totalSubtareasCompletadas} de ${sprint.totalSubtareas} subtareas completadas',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Icon _buildStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'En progreso':
        icon = Icons.timer;
        color = Colors.orange;
        break;
      case 'Completado':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'Pendiente':
        icon = Icons.pending_actions;
        color = Colors.blue;
        break;
      default:
        icon = Icons.error;
        color = Colors.red;
        break;
    }

    return Icon(icon, color: color);
  }
}
