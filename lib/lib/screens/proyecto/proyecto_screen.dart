import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/organization/proyectos.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/sprint_list.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:lumotareas/lib/screens/crear_sprint/crear_sprint_screen.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/miembros_list.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/project_tile.dart';
import 'package:lumotareas/lib/screens/sprint/sprint_screen.dart';
import 'package:lumotareas/lib/widgets/floating_menu.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';
import 'package:lumotareas/lib/models/proyecto/proyecto.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class ProjectScreen extends StatefulWidget {
  final ProyectoFirestore proyecto;
  final List<Usuario> usuariosAsignados;
  final bool isPoppable;
  final Usuario currentUser;

  const ProjectScreen({
    super.key,
    required this.proyecto,
    required this.usuariosAsignados,
    required this.currentUser,
    this.isPoppable = true,
  });

  @override
  ProjectScreenState createState() => ProjectScreenState();
}

class ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar el proyecto cada vez que se inicia el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectDataProvider>(context, listen: false)
          .loadProyecto(widget.proyecto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProjectDataProvider>(
        builder: (context, projectProvider, _) {
          if (projectProvider.proyecto == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Proyecto proyectoObj = projectProvider.proyecto!;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  title: proyectoObj.proyecto.nombre,
                  isPoppable: widget.isPoppable,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProjectTile(
                          index: 0,
                          nombre: proyectoObj.proyecto.nombre,
                          descripcion: proyectoObj.proyecto.descripcion,
                        ),
                        MiembrosList(
                          usuariosAsignados: widget.usuariosAsignados,
                        ),
                        SprintList(
                          sprints: proyectoObj.sprints,
                          onTap: (sprint) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SprintScreen(
                                  sprintId: sprint.sprintFirestore.id,
                                  currentUser: widget.currentUser,
                                  miembros: widget.usuariosAsignados,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: MenuFlotante(
        mainIcon: Icons.menu,
        items: [
          {
            'label': 'Agregar sprint',
            'icon': Icons.add,
            'screen': CrearSprintScreen(
              currentUser: widget.currentUser,
              miembros: widget.usuariosAsignados,
            ),
          },
        ],
      ),
    );
  }
}
