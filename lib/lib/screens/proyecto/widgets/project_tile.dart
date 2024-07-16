import 'package:flutter/material.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class ProjectTile extends StatelessWidget {
  final int index;
  final String nombre;
  final String descripcion;

  const ProjectTile({
    super.key,
    required this.index,
    required this.nombre,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return StyledListTile(
      index: index,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            descripcion,
            style: const TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
