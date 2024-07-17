import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/auth_provider.dart';
import 'package:lumotareas/lib/services/user_data_service.dart';
import 'package:lumotareas/lib/services/access_service.dart';

class UserDataProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final UserDataService _userDataService = UserDataService();

  final Logger _logger = Logger();
  Usuario? _currentUser;
  bool _loadingUser = true; // Indicador de carga del usuario
  bool _loadingHistory = false;

  UserDataProvider(this._authProvider) {
    _initializeUser();
  }

  Future<void> initializeUser() async {
    await _initializeUser();
  }

  void reset() {
    _currentUser = null;
    _loadingUser = true;
    Logger().i('UserDataProvider reset.');
    notifyListeners();
  }

  Future<void> _initializeUser() async {
    _currentUser = _authProvider.currentUser;
    _loadingUser = false;
    _logger.i('UserDataProvider inicializado con usuario: $_currentUser');
    notifyListeners();
  }

  Usuario? get currentUser => _currentUser;
  bool get loadingUser => _loadingUser;

  final List<Logs> _history = [];
  List<Logs> get history => _history;

  bool get loadingHistory => _loadingHistory;

  Future<void> fetchHistory(String email) async {
    if (_currentUser == null) {
      return;
    }

    _loadingHistory = true;
    notifyListeners();

    try {
      _history.clear();
      _history.addAll(await AccessService.getLogs(email));
      _logger.i('Registros de actividad obtenidos correctamente');
    } catch (e) {
      _logger.e('Error al obtener logs: $e');
    } finally {
      _loadingHistory = false;
      notifyListeners();
    }
  }

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
