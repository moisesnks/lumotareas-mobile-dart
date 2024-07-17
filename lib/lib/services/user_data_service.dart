//Servicio de datos de usuario para manejar la información del usuario en la base de datos.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/response.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/services/database_service.dart';

/// Servicio de datos de usuario para manejar la información del usuario en la base de datos.
class UserDataService {
  final Logger _logger = Logger();
  final DatabaseService _databaseService = DatabaseService();

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
