//Servicio de datos de usuario para manejar la información del usuario en la base de datos.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/database_service.dart';

/// Servicio de datos de usuario para manejar la información del usuario en la base de datos.
class UserDataService {
  final Logger _logger = Logger();
  final DatabaseService _databaseService = DatabaseService();

  Future<Response<Usuario>> getDataById(String userId) async {
    try {
      Response response = await _databaseService.getDocument('users', userId);
      if (response.success) {
        return Response(
          success: true,
          data: Usuario.fromMap(userId, response.data),
          message: response.message,
        );
      } else {
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al obtener datos del usuario: $e');
      return Response(
        success: false,
        message: 'Error al obtener datos del usuario',
      );
    }
  }

  /// Crea un nuevo usuario en la base de datos.
  ///
  /// [user] es la instancia de [Usuario] que se va a crear.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  ///
  Future<Response<Usuario>> create(User firebaseUser,
      {String birthDate = ''}) async {
    try {
      // Crear instancia de Usuario desde FirebaseUser
      Usuario usuario = Usuario.fromFirebaseUser(firebaseUser);

      // Aplicar copyWith solo si birthDate no está vacío
      if (birthDate.isNotEmpty) {
        usuario = usuario.copyWith(birthdate: birthDate);
      }

      // Agregar documento a Firestore
      Response response = await _databaseService.addDocument(
        'users',
        documentId: firebaseUser.uid,
        data: usuario.toMap(),
      );

      // Verificar la respuesta del servicio de base de datos
      if (response.success) {
        // Obtener los datos del usuario recién creado con el getData
        Response<Usuario> userResponse = await getData(firebaseUser);
        if (userResponse.success) {
          return Response(
            success: true,
            data: userResponse.data,
            message: response.message,
          );
        } else {
          return Response(
            success: false,
            message: userResponse.message,
          );
        }
      } else {
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al crear usuario: $e');
      return Response(
        success: false,
        message: 'Error al crear usuario',
      );
    }
  }

  /// Obtiene los datos de un usuario de Firebase.
  ///
  /// [firebaseUser] es la instancia de [User] de Firebase Authentication.
  /// Devuelve una [Response] con la instancia de [Usuario] que representa al usuario o un mensaje de error.
  Future<Response<Usuario>> getData(User firebaseUser) async {
    try {
      Response response =
          await _databaseService.getDocument('users', firebaseUser.uid);
      if (response.success) {
        return Response(
          success: true,
          data: Usuario.fromMap(firebaseUser.uid, response.data),
          message: response.message,
        );
      } else {
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al obtener datos del usuario: $e');
      return Response(
        success: false,
        message: 'Error al obtener datos del usuario',
      );
    }
  }

  /// Actualiza los datos de un usuario en la base de datos.
  ///
  /// [user] es la instancia de [Usuario] que se va a actualizar.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Usuario>> update(Usuario user) async {
    try {
      Response response = await _databaseService.updateDocument(
        'users',
        user.uid,
        user.toMap(),
      );
      if (response.success) {
        return Response(
          success: true,
          data: user,
          message: response.message,
        );
      } else {
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al actualizar datos del usuario: $e');
      return Response(
        success: false,
        message: 'Error al actualizar datos del usuario',
      );
    }
  }
}
