import 'package:flutter/material.dart';
import 'package:lumotareas/models/project.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';

class ProyectosAsignadosButton extends StatelessWidget {
  final String userId;
  final List<Project> proyectos;

  const ProyectosAsignadosButton({
    super.key,
    required this.userId,
    required this.proyectos,
  });

  List<Project> getProyectosAsignados() {
    // Filtrar los proyectos asignados al usuario actual
    return proyectos
        .where((project) => project.asignados.contains(userId))
        .toList();
  }

  void _showAssignedProjects(BuildContext context) {
    List<Project> assignedProjects = getProyectosAsignados();

    if (assignedProjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes proyectos asignados.'),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: assignedProjects.length,
            itemBuilder: (context, index) {
              Project project = assignedProjects[index];
              return ListTile(
                title: Text(
                  project.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  project.descripcion,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                onTap: () => _showProjectDetails(context, project),
              );
            },
          );
        },
      );
    }
  }

  void _showProjectDetails(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                project.nombre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Descripción: ${project.descripcion}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Asignados: ${project.asignados.join(', ')}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Project> assignedProjects = getProyectosAsignados();

    return IconBox(
      icon: Icons.assignment,
      label: 'Proyectos asignados',
      count: assignedProjects.length,
      showCount: true,
      onTap: () => _showAssignedProjects(context),
    );
  }
}
