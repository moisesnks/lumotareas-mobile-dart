import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/project.dart';
import 'package:lumotareas/models/solicitud.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/list_items_widget.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/widgets/flexible_wrap_widget.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'apps/miembros_button.dart';
import 'apps/solicitudes_button.dart';
import 'apps/proyectos_asignados_button.dart';
import 'apps/proyectos_button.dart';
import 'apps/solicitudes_org_button.dart';

class AppsMenu extends StatefulWidget {
  final String currentOrganizationId;
  final Logger logger;
  final OrganizationService organizationService;
  final Usuario currentUser; // Añadir currentUser como parámetro

  const AppsMenu({
    super.key,
    required this.currentOrganizationId,
    required this.logger,
    required this.organizationService,
    required this.currentUser, // Añadir currentUser como parámetro
  });

  @override
  AppsMenuState createState() => AppsMenuState();
}

class AppsMenuState extends State<AppsMenu> {
  late List<Project> _proyectos = [];
  bool _isLoading = true;
  List<SolicitudOrg>? _solicitudesOrg;

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
    _cargarSolicitudesOrg();
  }

  Future<void> _cargarProyectos() async {
    String? orgName = await PreferenceService.getCurrentOrganization();
    if (orgName == null) {
      widget.logger.e('No se pudo obtener el nombre de la organización.');
      return;
    }
    final result = await widget.organizationService.getProjects(orgName);
    if (result['success']) {
      List<Project> projects = result['projects'];
      setState(() {
        _proyectos = projects;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Manejar el error si es necesario
      widget.logger.i(result['message']);
    }
  }

  Future<void> _cargarSolicitudesOrg() async {
    widget.logger.i('Cargando solicitudes de la organización...');
    List<SolicitudOrg> solicitudes = await widget.organizationService
        .getSolicitudes(widget.currentOrganizationId, widget.currentUser);
    setState(() {
      _solicitudesOrg = solicitudes;
    });
    widget.logger.i('Solicitudes de la organización: $_solicitudesOrg');
  }

  void _showProjectList() {
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
          return ListItems<Project>(
            items: _proyectos,
            itemBuilder: (context, project) => ListTile(
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
    return _buildOrganizationWidget(widget.currentUser);
  }

  Widget _buildOrganizationWidget(Usuario currentUser) {
    if (currentUser.organizaciones == null ||
        currentUser.organizaciones!.isEmpty ||
        widget.currentOrganizationId.isEmpty) {
      return _buildNoOrgWidget(currentUser);
    } else {
      return _buildOrgDetailsWidget(currentUser);
    }
  }

  Widget _buildNoOrgWidget(Usuario currentUser) {
    return Contenedor(
      direction: Axis.vertical,
      children: [
        const Parrafo(
          fontSize: 16,
          texto:
              'Actualmente, no estás afiliado a ninguna organización. Puedes crear tu propia organización o explorar otras existentes para enviar solicitudes de afiliación.',
        ),
        const SizedBox(height: 16),
        if (currentUser.solicitudes.isNotEmpty)
          SolicitudesButton(solicitudes: currentUser.solicitudes),
      ],
    );
  }

  Widget _buildOrgDetailsWidget(Usuario currentUser) {
    return FutureBuilder(
      future: widget.organizationService
          .getOrganization(widget.currentOrganizationId),
      builder: (
        BuildContext context,
        AsyncSnapshot<Map<String, dynamic>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 10);
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.toString()}');
        }
        if (snapshot.hasData) {
          final Organization organization = snapshot.data!['organization'];
          widget.logger.i('Organización actual: $organization');
          return FlexibleWrap(
            color: Colors.transparent,
            spacing: 10,
            children: [
              ProyectosButton(
                proyectos: _proyectos,
                isLoading: _isLoading,
                cargarProyectos: _cargarProyectos,
                showProjectList: _showProjectList,
              ),
              ProyectosAsignadosButton(
                proyectos: _proyectos,
                userId: currentUser.uid,
              ),
              MiembrosButton(
                miembros: organization.miembros,
                orgName: organization.nombre,
              ),
              if (currentUser.isOwnerOfOrganization(organization.nombre))
                _solicitudesOrg == null
                    ? const CircularProgressIndicator()
                    : SolicitudesOrgButton(
                        orgName: organization.nombre,
                        currentUser:
                            currentUser, // Pasar currentUser como parámetro
                        solicitudes: _solicitudesOrg!,
                      ),
              SolicitudesButton(solicitudes: currentUser.solicitudes),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
