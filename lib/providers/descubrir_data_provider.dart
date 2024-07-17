import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/organization_data_service.dart';

class DescubrirDataProvider with ChangeNotifier {
  List<Organizacion> _organizacionesDestacadas = [];
  bool _isLoading = false;

  List<Organizacion> get organizacionesDestacadas => _organizacionesDestacadas;
  bool get isLoading => _isLoading;

  Future<void> obtenerOrganizacionesDestacadas(
      {bool forceReload = false}) async {
    if (_organizacionesDestacadas.isNotEmpty && !forceReload) {
      return; // No se hace fetch si ya existen datos y no se fuerza la recarga
    }

    _isLoading = true;
    notifyListeners();

    final Response<List<Organizacion>> response =
        await OrganizationDataService().getPopulars();
    if (response.success) {
      _organizacionesDestacadas = response.data!;
    } else {
      _organizacionesDestacadas = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> likeOrganizacion(
      Organizacion organizacion, Usuario currentUser, bool addLike) async {
    final Response<bool> response = await OrganizationDataService()
        .likeOrganization(organizacion, currentUser);
    return response.success;
  }

  Future<List<Organizacion>> obtenerOrganizaciones(String query) async {
    final Response<List<Organizacion>> response =
        await OrganizationDataService().getOrganizationsByPrefix(query);
    if (response.success) {
      return response.data!;
    } else {
      return [];
    }
  }
}
