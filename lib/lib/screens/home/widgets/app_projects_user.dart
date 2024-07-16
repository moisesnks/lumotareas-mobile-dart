import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/proyecto/proyecto_screen.dart';
import 'package:lumotareas/lib/widgets/icon_box.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class ProjectsUserButton extends StatelessWidget {
  final List<ProyectoFirestore> proyectos;
  final Usuario currentUser;
  final List<Usuario> miembrosOrganizacion;

  const ProjectsUserButton({
    super.key,
    required this.proyectos,
    required this.currentUser,
    required this.miembrosOrganizacion,
  });

  void showProjectsList(BuildContext context) {
    final List<ProyectoFirestore> proyectosUsuario = proyectos
        .where((proyecto) => proyecto.asignados.contains(currentUser.uid))
        .toList();

    if (proyectosUsuario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay proyectos en los que estés asignado.'),
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: const Color.fromARGB(155, 56, 45, 93),
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: proyectosUsuario.length,
            itemBuilder: (BuildContext context, int index) {
              final ProyectoFirestore proyecto = proyectosUsuario[index];
              return StyledListTile(
                index: index,
                leading: const Icon(Icons.business),
                title: Text(proyecto.nombre),
                subtitle: Text(proyecto.descripcion),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectScreen(
                        currentUser: currentUser,
                        proyecto: proyecto,
                        miembrosOrganizacion: miembrosOrganizacion,
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
      label: 'Mis Proyectos',
      count: proyectos
          .where((proyecto) => proyecto.asignados.contains(currentUser.uid))
          .length,
      showCount: true,
      onTap: () => showProjectsList(context),
    );
  }
}
