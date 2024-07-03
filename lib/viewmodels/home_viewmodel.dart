import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/services/organization_service.dart'; // Importa el servicio de organización
import 'package:lumotareas/screens/detalle_org_screen.dart';
import 'package:lumotareas/screens/nueva_org_screen.dart';
import 'package:lumotareas/screens/loading_buscando_org.dart';

class HomeViewModel extends ChangeNotifier {
  final TextEditingController orgController = TextEditingController();
  final Logger _logger = Logger();
  final OrganizationService _organizationService =
      OrganizationService(); // Instancia del servicio de organización

  void handleArrowTap(BuildContext context) async {
    String orgName = orgController.text.trim();

    if (orgName.isNotEmpty) {
      // Mostrar pantalla de búsqueda
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuscandoOrgScreen(),
        ),
      );

      // Un delay para simular una búsqueda en Firestore
      await Future.delayed(const Duration(milliseconds: 1000));

      // Pop de la pantalla de búsqueda
      if (context.mounted) {
        Navigator.pop(context);
      }

      try {
        _logger.i('Buscando la organización $orgName...');

        // Consultar organización utilizando OrganizationService
        var result = await _organizationService.getOrganization(orgName);

        if (result['success']) {
          // Organización encontrada, navegar a la pantalla de detalles
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleOrgScreen(
                    orgName: orgName, organization: result['organization']),
              ),
            );
          }
        } else {
          // Organización no encontrada, navegar a la página de no encontrada
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NuevaOrgScreen(orgName: orgName),
              ),
            );
          }
        }
      } catch (e) {
        _logger.e('Error al manejar el tap de la flecha: $e');
        // Mostrar un modal de error
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    const Text('Hubo un problema al buscar la organización'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      _logger.w('Por favor, ingresa el nombre de tu organización');
      // Mostrar un modal de error
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Por favor, ingresa el nombre de tu organización'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
