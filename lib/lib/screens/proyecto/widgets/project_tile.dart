import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class ProjectTile extends StatelessWidget {
  final int index;
  final ProyectoFirestore proyecto;
  final Usuario currentUser;
  final List<Usuario> miembrosOrganizacion;

  const ProjectTile({
    super.key,
    required this.index,
    required this.proyecto,
    required this.currentUser,
    required this.miembrosOrganizacion,
  });

  @override
  Widget build(BuildContext context) {
    final Usuario createdBy = miembrosOrganizacion
        .firstWhere((miembro) => miembro.uid == proyecto.createdBy);
    return StyledListTile(
      index: index,
      leading: const Icon(Icons.folder),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proyecto.nombre,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Creado por ${createdBy.nombre}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Text(
        proyecto.descripcion,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
