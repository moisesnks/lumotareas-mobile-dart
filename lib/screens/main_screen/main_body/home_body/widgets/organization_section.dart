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
        color: const Color(0xFF1A1A1A),
        children: [
          const Parrafo(
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
            return Miembros(
              miembros: organization.miembros,
              onTap: () {
                if (organization.miembros > 0) {
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
                                'Lista de miembros',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: organization.miembros,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'Miembro ${index + 1}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sin miembros'),
                        content: const Text(
                            'Aún no hay miembros en su organización. Puedes invitar a nuevos miembros.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          } else {
            return const Text('Error: No se pudo obtener la organización');
          }
        },
      );
    }
  }
}
