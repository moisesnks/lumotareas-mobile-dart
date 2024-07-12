import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/models/organization.dart';
import 'miembros.dart';
import 'solicitudes.dart';

class OrganizationSection extends StatelessWidget {
  final String currentOrganizationId;
  final Logger logger;
  final OrganizationService organizationService;

  const OrganizationSection({
    super.key,
    required this.currentOrganizationId,
    required this.logger,
    required this.organizationService,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser;

    if (currentUser == null) {
      return const SizedBox
          .shrink(); // Return an empty widget if no user is logged in
    }

    if (currentUser.organizaciones == null ||
        currentUser.organizaciones!.isEmpty ||
        currentOrganizationId.isEmpty) {
      return Contenedor(
        direction: Axis.vertical,
        children: [
          const Parrafo(
            fontSize: 16,
            texto:
                'Actualmente, no estás afiliado a ninguna organización. Puedes crear tu propia organización o explorar otras existentes para enviar solicitudes de afiliación.',
          ),
          const SizedBox(height: 16),
          Solicitudes(
            solicitudes: currentUser.solicitudes ?? [],
          ),
        ],
      );
    } else {
      return FutureBuilder(
        future: organizationService.getOrganization(currentOrganizationId),
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
            logger.i('Organización actual: $organization');
            return Miembros(miembros: organization.miembros);
          }
          return const SizedBox.shrink();
        },
      );
    }
  }
}
