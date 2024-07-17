import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/services/organization_data_service.dart';

class OrganizationDataProvider with ChangeNotifier {
  final OrganizationDataService _organizationDataService =
      OrganizationDataService();
  final Logger _logger = Logger();
  Organizacion? currentOrganization;

  bool _isLoading = false; // Control de carga

  Organizacion? get organization => currentOrganization;

  void reset() {
    currentOrganization = null;
    Logger().i('OrganizationDataProvider reset.');
    notifyListeners();
  }

  Future<void> createProyecto(
      BuildContext context, ProyectoFirestore proyecto) async {
    if (currentOrganization == null) {
      _logger.e('No se puede crear un proyecto sin una organización');
      throw Exception('No se puede crear un proyecto sin una organización');
    }
    _logger.i('Creando proyecto: ${proyecto.nombre}');
    Navigator.pushNamed(context, '/loading', arguments: 'Creando proyecto...');
    final response = await _organizationDataService.createProyecto(
        currentOrganization!, proyecto);
    if (response.success) {
      _logger.i('Proyecto creado correctamente');
      currentOrganization = response.data;
      notifyListeners();
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      _logger.e('Error al crear proyecto: ${response.message}');
      throw Exception('Error al crear proyecto: ${response.message}');
    }
  }

  Future<void> fetchOrganization(BuildContext context, String orgId,
      {bool forceFetch = false}) async {
    _logger.i('Obteniendo datos de la organización con ID: $orgId');

    if (!forceFetch &&
        currentOrganization != null &&
        currentOrganization!.nombre == orgId) {
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
        notifyListeners(); // Aseguramos que los listeners sean notificados
      } else {
        _logger.e(
            'Error al obtener datos de la organización: ${response.message}');
      }
    } catch (e) {
      _logger.e('Error al obtener datos de la organización: $e');
    } finally {
      _isLoading = false; // Marcamos que la carga ha finalizado
    }
  }
}
