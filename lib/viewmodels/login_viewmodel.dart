import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  String? _message;

  String? get message => _message;

  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

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
    // Pushea una ventana de carga
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Iniciando sesión con Google...'),
            ],
          ),
        ),
      );
    }));

    try {
      Usuario? user = await _userService.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
      } else {
        _logger.w('Inicio de sesión fallido con Google');
        setMessage(
            'Inicio de sesión fallido con Google, usuario no encontrado');
        if (context.mounted) {
          Navigator.pop(context);
        }
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
      // Pushea una ventana de carga
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Iniciando sesión...'),
              ],
            ),
          ),
        );
      }));

      Usuario? user =
          await _userService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
      } else {
        _logger.w('Inicio de sesión fallido con correo y contraseña');
        setMessage('Inicio de sesión fallido con correo y contraseña');
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con correo y contraseña: $e');
      setMessage('Error al iniciar sesión con correo y contraseña');
    }
  }

  // Método para cerrar sesión
  Future<void> signOut(BuildContext context) async {
    // Pushea una ventana de carga
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Cerrando sesión...'),
            ],
          ),
        ),
      );
    }));

    // 500ms de retraso para mostrar la ventana de carga
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _userService.signOut();
      _currentUser = null;
      _logger.d('Sesión cerrada correctamente');
      setMessage('Sesión cerrada correctamente');
      // navegar a '/login' y reemplazar todas las rutas anteriores
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      setMessage('Error al cerrar sesión');
    }
  }

  Future<Usuario?> registerUserWithEmailAndPassword(
      BuildContext context, Map<String, dynamic> formData) async {
    _logger.d('Datos del formulario desde LoginViewModel: $formData');

    // TODO: falta pantalla de carga?
    // Pushea una ventana de carga
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Registrando usuario...'),
            ],
          ),
        ),
      );
    }));

    // 500ms de retraso para mostrar la ventana de carga
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      Usuario? user =
          await _userService.registerUserWithEmailAndPassword(formData);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _logger.d(
            'Usuario registrado correctamente con correo y contraseña: ${user.email}');
        setMessage('Usuario registrado correctamente con correo y contraseña');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
        return user;
      } else {
        _logger.w('Registro de usuario fallido con correo y contraseña');
        setMessage('Registro de usuario fallido con correo y contraseña');
        if (context.mounted) {
          Navigator.pop(context);
        }
        return null;
      }
    } catch (e) {
      _logger.e('Error al registrar usuario con correo y contraseña: $e');
      return null;
    }
  }

  // Método para obtener el historial de inicios de sesión
  Future<void> getHistory(BuildContext context, String email) async {
    try {
      List<Map<String, dynamic>> history = await _userService.getHistory(email);
      _history = history;
      notifyListeners();
      _logger.d('Historial de inicios de sesión obtenido correctamente');
    } catch (e) {
      _logger.e('Error al obtener el historial de inicios de sesión: $e');
      setMessage('Error al obtener el historial de inicios de sesión');
    }
  }
}
