import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumotareas/lib/models/response.dart';
import 'package:lumotareas/lib/services/database_service.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class UserDataService {
  final Logger _logger = Logger();
  final DatabaseService _databaseService = DatabaseService();

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
