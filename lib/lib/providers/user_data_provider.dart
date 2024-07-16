import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/auth_provider.dart';
import 'package:lumotareas/lib/services/user_data_service.dart';

class UserDataProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final UserDataService _userDataService = UserDataService();
  final Logger _logger = Logger();
  Usuario? _currentUser;

  UserDataProvider(this._authProvider) {
    _currentUser = _authProvider.currentUser;
    _logger.i('UserDataProvider inicializado con usuario: $_currentUser');
  }

  Usuario? get currentUser => _currentUser;

  Future<void> updateUserData(BuildContext context, Usuario user) async {
    _logger.i('Actualizando datos del usuario: $user');
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    final response = await _userDataService.update(user);
    if (response.success) {
      _logger.i('Datos del usuario actualizados correctamente');
      _currentUser = user;
      notifyListeners();
    } else {
      _logger.e('Error al actualizar datos del usuario: ${response.message}');
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
