import 'package:lumotareas/services/firestore_service.dart';
import 'package:lumotareas/models/organization.dart';

class OrganizationService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Map<String, dynamic>> getOrganization(String orgName) async {
    final result =
        await _firestoreService.getDocument('organizations', orgName);

    if (result['found']) {
      // Convertir los datos en un objeto Organization
      Organization organization = Organization.fromMap(result['data']);
      return {
        'found': true,
        'organization': organization,
        'message': result['message'],
      };
    } else {
      return {
        'found': false,
        'message': result['message'],
      };
    }
  }
}
