import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> searchOrg(String orgName) async {
    try {
      // Consultar Firestore para buscar la organización
      var snapshot =
          await _firestore.collection('organizaciones').doc(orgName).get();

      if (snapshot.exists) {
        // Organización encontrada, devolver datos
        return {
          'found': true,
          'data': snapshot.data(),
          'message': 'Organización encontrada',
        };
      } else {
        // Organización no encontrada
        return {
          'found': false,
          'message': 'Organización no encontrada',
        };
      }
    } catch (e) {
      _logger.e('Error al buscar la organización: $e');
      return {
        'error': true,
        'message': 'Hubo un error al buscar la organización',
      };
    }
  }
}
