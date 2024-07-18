import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/solicitud.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/organization_data_service.dart';

class RequestDataProvider with ChangeNotifier {
  Solicitud? _solicitud;

  Solicitud? get solicitud => _solicitud;

  final OrganizationDataService _organizationDataService =
      OrganizationDataService();

  Future<void> fetchSolicitud(
      BuildContext context, String solicitudId, String orgName) async {
    final Solicitud? response =
        await _organizationDataService.getRequest(orgName, solicitudId);
    if (response != null) {
      _solicitud = response;
      notifyListeners();
    } else {
      // Handle error if needed
    }
  }

  Future<void> updateSolicitud(
      BuildContext context, Solicitud solicitud, Usuario currentUser) async {
    final Response<Solicitud> response =
        await _organizationDataService.updateRequest(currentUser, solicitud);
    if (response.success) {
      _solicitud = response.data;
      notifyListeners();
    } else {
      // Handle error if needed
    }
  }
}
