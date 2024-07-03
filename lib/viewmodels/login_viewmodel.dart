import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/user_service.dart';

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

  // Método para registrar un usuario con Google SignIn
  Future<void> registerUserWithGoogle() async {
    try {
      Usuario? newUser = await _userService.registerUserWithGoogle();
      if (newUser != null) {
        _currentUser = newUser;
        _logger
            .d('Usuario registrado correctamente con Google: ${newUser.email}');
        notifyListeners();
      } else {
        _logger.e('Error al registrar usuario con Google');
      }
    } catch (e) {
      _logger.e('Error en registerUserWithGoogle: $e');
    }
  }

  // Método para iniciar sesión con Google SignIn
  Future<void> signInWithGoogle() async {
    try {
      Usuario? user = await _userService.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        _logger.d('Inicio de sesión exitoso con Google: ${user.email}');
        setMessage('Inicio de sesión exitoso con Google');
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
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      Usuario? user =
          await _userService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        _currentUser = user;
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
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
