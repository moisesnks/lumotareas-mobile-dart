import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/proyecto/proyecto_screen.dart';
import 'package:lumotareas/lib/widgets/icon_box.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class ProjectsOrgButton extends StatelessWidget {
  final List<ProyectoFirestore> proyectos;
  final List<Usuario> miembros; // Lista de todos los miembros
  final Usuario currentUser;

  const ProjectsOrgButton({
    super.key,
    required this.proyectos,
    required this.miembros,
    required this.currentUser,
  });

  void showProjectsList(BuildContext context) {
    if (proyectos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay proyectos en esta organización.'),
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: const Color.fromARGB(155, 56, 45, 93),
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (BuildContext context, int index) {
              final ProyectoFirestore proyecto = proyectos[index];
              return StyledListTile(
                index: index,
                leading: const Icon(Icons.business),
                title: Text(proyecto.nombre),
                subtitle: Text(proyecto.descripcion),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectScreen(
                        currentUser: currentUser,
                        proyecto: proyecto,
                        miembrosOrganizacion: miembros,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.business,
      label: 'Proyectos',
      count: proyectos.length,
      showCount: true,
      onTap: () => showProjectsList(context),
    );
  }
}
