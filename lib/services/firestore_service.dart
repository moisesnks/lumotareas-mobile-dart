import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addDocument(String collectionName,
      String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data);
      _logger.d('Documento añadido a $collectionName con ID: $documentId');
      return {
        'success': true,
        'documentId': documentId,
        'message': 'Documento añadido correctamente a $collectionName',
      };
    } catch (e) {
      _logger.e('Error al añadir documento a $collectionName: $e');
      return {
        'error': true,
        'message': 'Hubo un error al añadir documento a $collectionName',
      };
    }
  }

  Future<Map<String, dynamic>> getDocument(
      String collectionName, String documentId) async {
    try {
      var snapshot =
          await _firestore.collection(collectionName).doc(documentId).get();

      if (snapshot.exists) {
        return {
          'found': true,
          'data': snapshot.data(),
          'message': '$collectionName encontrado',
        };
      } else {
        return {
          'found': false,
          'message': '$collectionName no encontrado',
        };
      }
    } catch (e) {
      _logger.e('Error al obtener $collectionName: $e');
      return {
        'error': true,
        'message': 'Hubo un error al obtener $collectionName',
      };
    }
  }

  Future<Map<String, dynamic>> updateDocument(String collectionName,
      String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
      _logger.d('Documento actualizado en $collectionName con ID: $documentId');
      return {
        'success': true,
        'message': 'Documento actualizado correctamente en $collectionName',
      };
    } catch (e) {
      _logger.e('Error al actualizar documento en $collectionName: $e');
      return {
        'error': true,
        'message': 'Hubo un error al actualizar documento en $collectionName',
      };
    }
  }

  Future<Map<String, dynamic>> deleteDocument(
      String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      _logger.d('Documento eliminado de $collectionName con ID: $documentId');
      return {
        'success': true,
        'message': 'Documento eliminado correctamente de $collectionName',
      };
    } catch (e) {
      _logger.e('Error al eliminar documento de $collectionName: $e');
      return {
        'error': true,
        'message': 'Hubo un error al eliminar documento de $collectionName',
      };
    }
  }
}
