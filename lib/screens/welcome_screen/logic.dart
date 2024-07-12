import 'package:flutter/material.dart';
import 'loading/loading_buscando.dart'; // pantalla de carga
import '../detalle_org/detalle_org_screen.dart'; // pantalla de detalles
import '../login_screen/login_screen.dart'; // pantalla de login
import 'nueva_org/nueva_org_screen.dart'; // pantalla de nueva organización
import 'package:logger/logger.dart'; // logger
import 'package:lumotareas/services/organization_service.dart'; // servicio de las organizaciones

class WelcomeScreenLogic {
  final TextEditingController organizationNameController =
      TextEditingController();

  final Logger _logger = Logger();
  final OrganizationService _organizationService = OrganizationService();
  final ImageProvider _welcomeImage =
      const AssetImage('assets/images/welcome.png');

  get welcomeImage => _welcomeImage;

  void dispose() {
    organizationNameController.dispose();
  }

  void handleLoginButtonPress(BuildContext context) {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  // Método para mostrar un dialogo de error genérico
  void showGenericErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
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

  // Método para validar el nombre de la organización
  bool validateOrganizationName(BuildContext context, String organizationName) {
    if (organizationName.isEmpty) {
      showGenericErrorDialog(
          context, 'El nombre de la organización no puede estar vacío');
      return false;
    }

    // Validación adicional con expresión regular
    final RegExp regex = RegExp(r'^[a-zA-Z]+$');
    if (!regex.hasMatch(organizationName)) {
      showGenericErrorDialog(context,
          'El nombre de la organización debe contener solo letras del alfabeto inglés (mayúsculas o minúsculas). No se permiten la letra ñ ni tildes.');
      return false;
    }

    return true;
  }

  Future<void> handleFloatingActionButtonPress(BuildContext context) async {
    _logger.i('Manejando el botón flotante de la pantalla de bienvenida');
    final organizationName = organizationNameController.text;

    // Validar el nombre de la organización
    if (!validateOrganizationName(context, organizationName)) {
      return;
    }

    // Navegar a la pantalla de carga
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BuscandoOrgScreen(),
      ),
    );

    // Tratar de obtener la organización
    try {
      _logger.i('Buscando la organización $organizationName...');

      // Consultar organización utilizando OrganizationService
      final result =
          await _organizationService.getOrganization(organizationName);

      if (result['success']) {
        // Organización encontrada, navegar a la pantalla de detalles
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleOrgScreen(
                organization: result['organization'],
              ),
            ),
          );
        }
      } else {
        // Organización no encontrada, navegar a la página de no encontrada
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NuevaOrgScreen(orgName: organizationName),
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Error al manejar el tap de la flecha: $e');
      // Mostrar un modal de error
      if (context.mounted) {
        showGenericErrorDialog(
            context, 'Hubo un problema al buscar la organización');
      }
    }
  }
}
