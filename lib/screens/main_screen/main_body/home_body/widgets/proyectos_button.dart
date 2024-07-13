import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/project.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:logger/logger.dart';

class Proyectos extends StatefulWidget {
  const Proyectos({
    super.key,
  });

  @override
  ProyectosState createState() => ProyectosState();
}

class ProyectosState extends State<Proyectos> {
  final OrganizationService _organizationService = OrganizationService();
  List<Project> _proyectos = [];
  bool _isLoading = true;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _cargarNombres();
  }

  Future<void> _cargarNombres() async {
    String? orgName = await PreferenceService.getCurrentOrganization();
    if (orgName != null) {
      final result = await _organizationService.getProjects(orgName);
      if (result['success']) {
        List<Project> projects = result['projects'];
        if (mounted) {
          setState(() {
            _proyectos = projects;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        // Manejar el error si es necesario
        _logger.i(result['message']);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Manejar el caso en que no haya una organización seleccionada
      _logger.e('No se encontró una organización actual.');
    }
  }

  void _showProjectList(BuildContext context) {
    if (_isLoading) {
      // Mostrar un indicador de carga si los datos aún se están cargando
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cargando proyectos, por favor espere...'),
        ),
      );
    } else if (_proyectos.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: const Color(0xFF111111),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Lista de proyectos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _proyectos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          _proyectos[index].nombre,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () =>
                            _showProjectDetails(context, _proyectos[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Mostrar un mensaje si no hay proyectos disponibles
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron proyectos.'),
        ),
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
    return IconBox(
      icon: Icons.work,
      label: 'Proyectos',
      count: _proyectos.length,
      showCount: true,
      onTap: () => _showProjectList(context),
    );
  }
}
