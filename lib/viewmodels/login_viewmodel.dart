import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:flutter/material.dart'; // Importante para usar Navigator

class LoginViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  String? _message;

  String? get message => _message;

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  String? readMessage() {
    final message = _message;
    _message = null;
    return message;
  }

  // Método para iniciar sesión con Google SignIn
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      Usuario? user = await _userService.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        _logger.d('Inicio de sesión exitoso con Google: ${user.email}');
        setMessage('Inicio de sesión exitoso con Google');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        _logger.w('Inicio de sesión fallido con Google');
        setMessage(
            'Inicio de sesión fallido con Google, usuario no encontrado');
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      setMessage('Error al iniciar sesión con Google');
    }
  }

  // Método para iniciar sesión con email y contraseña
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      Usuario? user =
          await _userService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        _currentUser = user;
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        _logger.w('Inicio de sesión fallido con correo y contraseña');
        setMessage('Inicio de sesión fallido con correo y contraseña');
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con correo y contraseña: $e');
      setMessage('Error al iniciar sesión con correo y contraseña');
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      await _userService.signOut();
      _currentUser = null;
      _logger.d('Sesión cerrada correctamente');
      setMessage('Sesión cerrada correctamente');
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      setMessage('Error al cerrar sesión');
    }
  }
}
