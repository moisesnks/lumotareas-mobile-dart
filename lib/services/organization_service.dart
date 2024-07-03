import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/services/firestore_service.dart';

class OrganizationService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Map<String, dynamic>> registerSolicitud(
      String orgName, Map<String, dynamic> solicitud, String uid) async {
    // Crear un mapa con los datos de la solicitud
    Map<String, dynamic> data = {
      'solicitud': solicitud,
      'uid': uid,
      'estado': 'pendiente',
      'fecha': DateTime.now().toString(),
    };
    try {
      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/solicitudes',
          null, // Firestore generates an ID automatically
          data);

      if (result['success']) {
        return {
          'success': true,
          'message': 'Solicitud registrada correctamente',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al registrar la solicitud',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar la solicitud: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getOrganization(String orgName) async {
    try {
      final result =
          await _firestoreService.getDocument('organizaciones', orgName);

      if (result['found']) {
        // Convertir los datos en un objeto Organization
        Organization organization = Organization.fromMap(result['data']);
        return {
          'success': true,
          'organization': organization,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener la organización: $e',
      };
    }
  }

  Future<Map<String, dynamic>> createOrganization(
      Organization organization) async {
    try {
      // Convertir el objeto Organization a un mapa para almacenarlo
      Map<String, dynamic> data = organization.toMap();

      final result = await _firestoreService.addDocument(
          'organizaciones', organization.nombre, data);

      if (result['success']) {
        // Crear la colección 'solicitudes' dentro de la organización
        await _firestoreService.addDocument(
            'organizaciones/${organization.nombre}/solicitudes',
            'initial',
            {'message': 'Initial solicitud document'});

        return {
          'success': true,
          'message':
              'Organización creada correctamente con la colección solicitudes',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear la organización',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear la organización: $e',
      };
    }
  }
}
