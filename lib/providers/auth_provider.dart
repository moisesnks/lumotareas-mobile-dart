import 'package:flutter/material.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/organization_data_provider.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Usuario? _currentUser;
  bool _isLoading = false;
  String _error = '';

  Usuario? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;

  set currentUser(Usuario? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    setLoading(true);
    setError(''); // Reset error

    // Navega a la pantalla de carga
    Navigator.pushNamed(context, '/loading',
        arguments: 'Iniciando sesión con Google...');

    Response<Usuario> response = await _authService.loginWithGoogle();
    setLoading(false);

    if (response.success) {
      currentUser =
          response.data; // Aquí usamos el setter para actualizar currentUser
      // Inicializa el UserDataProvider
      if (context.mounted) {
        Provider.of<UserDataProvider>(context, listen: false).initializeUser();
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      setError(response.message);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    if (context.mounted) {
      Navigator.pushNamed(context, '/loading', arguments: 'Cerrando sesión...');
      await Future.delayed(const Duration(seconds: 1));
    }
    await _authService.logout();
    currentUser = null;
    if (context.mounted) {
      _resetAllProviders(context);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  void _resetAllProviders(BuildContext context) {
    Provider.of<OrganizationDataProvider>(context, listen: false).reset();
    Provider.of<UserDataProvider>(context, listen: false).reset(); // Añadido
  }
}
