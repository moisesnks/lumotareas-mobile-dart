import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/services/organization_data_service.dart';

class OrganizationDataProvider with ChangeNotifier {
  final OrganizationDataService _organizationDataService =
      OrganizationDataService();
  final Logger _logger = Logger();
  Organizacion? currentOrganization;

  bool _isLoading = false; // Control de carga

  Organizacion? get organization => currentOrganization;

  Future<void> fetchOrganization(BuildContext context, String orgId) async {
    _logger.i('Obteniendo datos de la organización con ID: $orgId');
    if (currentOrganization != null && currentOrganization!.nombre == orgId) {
      _logger.i('Datos de la organización ya están disponibles localmente');
      return;
    }

    if (_isLoading) {
      _logger.w('La solicitud de datos de la organización está en curso');
      return;
    }

    _isLoading = true; // Marcamos que la carga está en progreso

    try {
      final response = await _organizationDataService.getData(orgId);
      if (response.success) {
        currentOrganization = response.data;
        _logger.i('Datos de la organización obtenidos correctamente');
      } else {
        _logger.e(
            'Error al obtener datos de la organización: ${response.message}');
      }
    } catch (e) {
      _logger.e('Error al obtener datos de la organización: $e');
    } finally {
      _isLoading = false; // Marcamos que la carga ha finalizado

      // Notificamos a los listeners solo si el widget aún está montado
      if (context.mounted) {
        notifyListeners();
      }
    }
  }
}
