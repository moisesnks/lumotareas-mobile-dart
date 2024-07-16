import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/sprint.dart';
import 'package:lumotareas/lib/models/proyecto/proyecto.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:lumotareas/lib/screens/crear_tarea/crear_tarea_screen.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/miembros_list.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/sprint_tile.dart';
import 'package:lumotareas/lib/screens/sprint/widgets/tareas_list.dart';
import 'package:lumotareas/lib/widgets/floating_menu.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';
import 'package:lumotareas/lib/utils/time.dart';
import 'package:provider/provider.dart';

class SprintScreen extends StatelessWidget {
  final String sprintId;
  final Usuario currentUser;
  final List<Usuario> miembros;

  const SprintScreen({
    super.key,
    required this.sprintId,
    required this.currentUser,
    required this.miembros,
  });

  @override
  Widget build(BuildContext context) {
    final proyectoProvider = Provider.of<ProjectDataProvider>(context);
    if (proyectoProvider.proyecto == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final Proyecto proyectoObj = proyectoProvider.proyecto!;
    if (proyectoObj.sprints.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No hay sprints en este proyecto'),
        ),
      );
    }

    final Sprint sprint = proyectoObj.sprints.firstWhere(
        (sprint) => sprint.sprintFirestore.id == sprintId, orElse: () {
      Logger().e('Sprint ha sido eliminado o no existe');
      return Sprint.empty();
    });
    Utils.formatTimestamp(sprint.sprintFirestore.startDate);
    Utils.formatTimestamp(sprint.sprintFirestore.endDate);

    final List<Usuario> usuariosAsignados = miembros.where((miembro) {
      return sprint.sprintFirestore.members.contains(miembro.uid);
    }).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header(
              title: sprint.sprintFirestore.name,
              isPoppable: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SprintTile(
                      index: 1,
                      sprint: sprint,
                      onTap: () {
                        Logger().i('SprintTile tapped');
                      },
                    ),
                    MiembrosList(
                        miembrosOrganizacion: miembros,
                        userId: currentUser.uid,
                        proyecto: proyectoObj.proyecto,
                        usuariosAsignados: usuariosAsignados),
                    TareasList(
                      tareas: sprint.tareas,
                      currentUser: currentUser,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MenuFlotante(
        mainIcon: Icons.menu,
        items: [
          {
            'label': 'Agregar tarea',
            'icon': Icons.add,
            'screen': CrearTareaScreen(
                currentUser: currentUser, miembros: miembros, sprint: sprint),
          },
          {
            'label': 'Borrar sprint',
            'icon': Icons.delete,
            'screen': ConfirmDeleteSprintScreen(sprint: sprint.sprintFirestore),
          },
        ],
      ),
    );
  }
}

class ConfirmDeleteSprintScreen extends StatelessWidget {
  final SprintFirestore sprint;

  const ConfirmDeleteSprintScreen({super.key, required this.sprint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar eliminación'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Estás seguro de que quieres eliminar este sprint?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final proyectoProvider = Provider.of<ProjectDataProvider>(
                        context,
                        listen: false);
                    proyectoProvider.deleteSprint(context, sprint);
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
