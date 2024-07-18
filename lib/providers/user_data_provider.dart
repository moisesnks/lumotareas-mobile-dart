import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/solicitudes.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/auth_provider.dart';
import 'package:lumotareas/services/organization_data_service.dart';
import 'package:lumotareas/services/user_data_service.dart';
import 'package:lumotareas/services/access_service.dart';

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
    _history.clear();
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

  Future<void> registerSolicitud(BuildContext context, String orgName,
      {required Map<String, dynamic> respuestas}) async {
    if (_currentUser == null) {
      return;
    }

    Navigator.pushNamed(context, '/loading',
        arguments: 'Enviando solicitud...');

    final Response<String> response = await OrganizationDataService()
        .addRequest(orgName, respuestas, _currentUser!);
    if (response.success) {
      _logger.i('Solicitud registrada correctamente');
      String documentId = response.data!;
      Solicitudes solicitud = Solicitudes(
        id: documentId,
        orgName: orgName,
      );
      _currentUser!.solicitudes.add(solicitud);
      if (context.mounted) {
        updateUserData(context, _currentUser!);
      }
    } else {
      _logger.e('Error al registrar solicitud: ${response.message}');
    }
    if (context.mounted) {
      Navigator.pop(context); // Cerrar pantalla de carga
      Navigator.pop(context); // Cerrar pantalla de solicitud
    }
  }

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

  Future<void> fetchUserData(BuildContext context) async {
    if (_currentUser == null) {
      return;
    }

    _loadingUser = true;
    notifyListeners();

    final response = await _userDataService.getDataById(_currentUser!.uid);
    if (response.success) {
      _currentUser = response.data;
      _logger.i('Datos del usuario obtenidos correctamente');
    } else {
      _logger.e('Error al obtener datos del usuario: ${response.message}');
    }

    _loadingUser = false;
    notifyListeners();
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
