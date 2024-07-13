import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';
import 'package:lumotareas/models/project.dart';

class ProyectosButton extends StatelessWidget {
  final List<Project> proyectos;
  final bool isLoading;
  final VoidCallback cargarProyectos;
  final VoidCallback showProjectList;

  const ProyectosButton({
    super.key,
    required this.proyectos,
    required this.isLoading,
    required this.cargarProyectos,
    required this.showProjectList,
  });

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.work,
      label: 'Proyectos',
      count: proyectos.length,
      showCount: true,
      onTap: () => showProjectList(),
    );
  }
}
