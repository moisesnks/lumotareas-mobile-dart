import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/solicitud.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/widgets/flexible_wrap_widget.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'apps/miembros_button.dart';
import 'apps/solicitudes_button.dart';
import 'apps/proyectos_button.dart';
import 'apps/solicitudes_org_button.dart';

class AppsMenu extends StatefulWidget {
  final String currentOrganizationId;
  final Logger logger;
  final OrganizationService organizationService;

  const AppsMenu({
    super.key,
    required this.currentOrganizationId,
    required this.logger,
    required this.organizationService,
  });

  @override
  AppsMenuState createState() => AppsMenuState();
}

class AppsMenuState extends State<AppsMenu> {
  late Future<List<SolicitudOrg>> solicitudesOrgFuture;

  @override
  void initState() {
    super.initState();
    solicitudesOrgFuture = _loadSolicitudes();
  }

  Future<List<SolicitudOrg>> _loadSolicitudes() async {
    final Usuario? currentUser =
        Provider.of<LoginViewModel>(context, listen: false).currentUser;
    if (currentUser != null) {
      Future<List<SolicitudOrg>> solicitudes = widget.organizationService
          .getSolicitudes(widget.currentOrganizationId, currentUser);
      return solicitudes;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final Usuario? currentUser =
        Provider.of<LoginViewModel>(context).currentUser;

    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return _buildOrganizationWidget(currentUser);
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
              const ProyectosButton(),
              MiembrosButton(
                miembros: organization.miembros,
                orgName: organization.nombre,
              ),
              if (currentUser.isOwnerOfOrganization(organization.nombre))
                FutureBuilder<List<SolicitudOrg>>(
                  future: solicitudesOrgFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      return SolicitudesOrgButton(
                        orgName: organization.nombre,
                        currentUser: currentUser,
                        solicitudes: snapshot.data!,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              SolicitudesButton(solicitudes: currentUser.solicitudes),
              // TODO: Agregar un widget para ver la organización y poder editarla
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
