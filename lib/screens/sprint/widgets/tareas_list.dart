/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/firestore/tareas.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/tarea/tarea_screen.dart';
import 'package:lumotareas/utils/constants.dart';
import 'package:lumotareas/widgets/styled_list_tile.dart';

class TareasList extends StatefulWidget {
  final List<TareaFirestore> tareas;
  final Usuario currentUser;

  const TareasList({
    super.key,
    required this.tareas,
    required this.currentUser,
  });

  @override
  TareasListState createState() => TareasListState();
}

class TareasListState extends State<TareasList> {
  bool _isListVisible = false;

  Widget _buildButton(Icon icon, Function() onTap, Color? backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onTap,
      ),
    );
  }

  void _toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
      Logger().i(_isListVisible
          ? 'Mostrar lista de tareas'
          : 'Ocultar lista de tareas');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledListTile(
          index: 0,
          leading: const Icon(Icons.task),
          title: const Text('Tareas'),
          trailing: _buildButton(
            Icon(
              _isListVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white,
            ),
            _toggleListVisibility,
            primaryColor,
          ),
          subtitle: Text(
            '${widget.tareas.length} tarea${widget.tareas.length == 1 ? '' : 's'}',
          ),
          onTap: _toggleListVisibility,
        ),
        if (_isListVisible)
          ...widget.tareas.map((tarea) {
            final int index = widget.tareas.indexOf(tarea);
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
                      currentUser: widget.currentUser,
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
          }),
      ],
    );
  }
}
