import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addDocument(String collectionName,
      String? documentId, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef;

      if (documentId != null) {
        docRef = _firestore.collection(collectionName).doc(documentId);
        await docRef.set(data);
      } else {
        docRef = await _firestore.collection(collectionName).add(data);
      }

      _logger.d('Documento añadido a $collectionName con ID: ${docRef.id}');
      return {
        'success': true,
        'documentId': docRef.id,
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

  Future<Map<String, dynamic>> getCollection(String collectionName,
      {int limit = 10, String? orderByField, bool descending = false}) async {
    try {
      Query<Map<String, dynamic>> query =
          FirebaseFirestore.instance.collection(collectionName);

      // Añadir ordenamiento si orderByField no es nulo
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      var snapshot = await query.limit(limit).get();

      if (snapshot.docs.isNotEmpty) {
        var filteredDocs =
            snapshot.docs.where((doc) => doc.id != 'initial').toList();

        return {
          'found': filteredDocs.isNotEmpty,
          'data': filteredDocs.map((doc) => doc.data()).toList(),
          'message': filteredDocs.isNotEmpty
              ? '$collectionName encontrado'
              : '$collectionName no encontrado',
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
        'message': 'Hubo un error al obtener $collectionName: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getDocumentsByPrefix(
      String collectionName, String prefix) async {
    try {
      var snapshot = await _firestore
          .collection(collectionName)
          .orderBy(FieldPath.documentId)
          .startAt([prefix]).endAt(['$prefix\uf8ff']).get();

      if (snapshot.docs.isNotEmpty) {
        return {
          'found': true,
          'data': snapshot.docs.map((doc) => doc.data()).toList(),
          'message': 'Documentos encontrados en $collectionName',
        };
      } else {
        return {
          'found': false,
          'message': 'No se encontraron documentos en $collectionName',
        };
      }
    } catch (e) {
      _logger.e('Error al buscar documentos en $collectionName: $e');
      return {
        'error': true,
        'message': 'Hubo un error al buscar documentos en $collectionName',
      };
    }
  }

  Future<Map<String, dynamic>> getDocument(
      String collectionName, String? documentId) async {
    try {
      if (documentId == null) {
        return {
          'error': true,
          'message': 'ID de documento es nulo',
        };
      }

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
