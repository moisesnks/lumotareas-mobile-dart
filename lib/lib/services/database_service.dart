import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/response.dart';

class DatabaseService {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Response<String>> addDocument(String collectionName,
      {String? documentId, required Map<String, dynamic> data}) async {
    try {
      DocumentReference docRef;

      if (documentId != null && documentId.isNotEmpty) {
        docRef = _firestore.collection(collectionName).doc(documentId);
        await docRef.set(data);
      } else {
        docRef = _firestore.collection(collectionName).doc();
        await docRef.set(data);
      }

      _logger.d('Documento añadido a $collectionName con ID: ${docRef.id}');
      return Response(
        success: true,
        data: docRef.id,
        message: 'Documento añadido correctamente a $collectionName',
      );
    } catch (e) {
      _logger.e('Error al añadir documento a $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al añadir documento a $collectionName: $e',
      );
    }
  }

  Future<Response<List<Map<String, dynamic>>>> getCollection(
      String collectionName,
      {int limit = 10,
      String? orderByField,
      bool descending = false}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionName);

      // Añadir ordenamiento si orderByField no es nulo
      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      var snapshot = await query.limit(limit).get();

      if (snapshot.docs.isNotEmpty) {
        var filteredDocs =
            snapshot.docs.where((doc) => doc.id != 'initial').toList();

        _logger.d(
            'Se ha solicitado la colección $collectionName y se ha encontrado con éxito.');
        return Response(
          success: true,
          data: filteredDocs.map((doc) => doc.data()).toList(),
          message: filteredDocs.isNotEmpty
              ? '$collectionName encontrado'
              : '$collectionName no encontrado',
        );
      } else {
        return Response(
          success: false,
          message: '$collectionName no encontrado',
        );
      }
    } catch (e) {
      _logger.e('Error al obtener $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al obtener $collectionName: $e',
      );
    }
  }

  Future<Response<Map<String, dynamic>?>> getDocument(
      String collectionName, String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection(collectionName).doc(documentId).get();

      if (doc.exists) {
        _logger.d(
            'Se ha solicitado el documento $documentId de $collectionName y se ha encontrado con éxito.');
        return Response(
          success: true,
          data: doc.data(),
          message:
              'Se ha encontrado el documento $documentId de $collectionName',
        );
      } else {
        return Response(
          success: false,
          message:
              'No se ha encontrado el documento $documentId de $collectionName',
        );
      }
    } catch (e) {
      _logger.e('Error al obtener $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al obtener $collectionName: $e',
      );
    }
  }

  Future<Response<List<Map<String, dynamic>>>> getDocumentsByPrefix(
      String collectionName, String prefix) async {
    try {
      var snapshot = await _firestore
          .collection(collectionName)
          .orderBy(FieldPath.documentId)
          .startAt([prefix]).endAt(['$prefix\uf8ff']).get();

      if (snapshot.docs.isNotEmpty) {
        _logger.d(
            'Se ha solicitado el documento con prefijo $prefix de $collectionName y se ha encontrado con éxito.');
        return Response(
          success: true,
          data: snapshot.docs.map((doc) => doc.data()).toList(),
          message:
              'Se ha encontrado el documento con prefijo $prefix de $collectionName',
        );
      } else {
        return Response(
          success: false,
          message: '$collectionName no encontrado',
        );
      }
    } catch (e) {
      _logger.e('Error al obtener $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al obtener $collectionName: $e',
      );
    }
  }

  Future<Response<void>> updateDocument(String collectionName,
      String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
      _logger.d(
          'El documento $documentId de $collectionName se actualizó correctamente');
      return Response(
        success: true,
        message:
            'El documento $documentId de $collectionName se actualizó correctamente',
      );
    } catch (e) {
      _logger.e('Error al actualizar $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al actualizar $collectionName: $e',
      );
    }
  }

  Future<Response<void>> deleteDocument(
      String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      _logger.d(
          'El documento $documentId de $collectionName se eliminó correctamente');
      return Response(
        success: true,
        message:
            'El documento $documentId de $collectionName se eliminó correctamente',
      );
    } catch (e) {
      _logger.e('Error al eliminar $collectionName: $e');
      return Response(
        success: false,
        message: 'Hubo un error al eliminar $collectionName: $e',
      );
    }
  }
}
