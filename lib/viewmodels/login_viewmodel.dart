import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Importar intl para formatear fechas y horas

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

  Future<void> _addLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toLocal(); // Asegúrate de usar la hora local
    final loginRecord = now.toIso8601String();

    List<String>? loginHistory = prefs.getStringList('loginHistory');
    if (loginHistory == null) {
      loginHistory = [];
    }

    loginHistory.add(loginRecord);
    await prefs.setStringList('loginHistory', loginHistory);
  }

  Future<List<Map<String, String>>> getLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final loginHistory = prefs.getStringList('loginHistory') ?? [];

    return loginHistory.map((record) {
      final dateTime = DateTime.parse(record).toLocal();
      final date = DateFormat('dd/MM/yyyy').format(dateTime);
      final time = DateFormat('HH:mm').format(dateTime);
      return {'date': date, 'time': time};
    }).toList();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
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
        await _addLoginHistory(); // Registrar la hora de inicio de sesión
        notifyListeners();
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
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

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
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
        await _addLoginHistory(); // Registrar la hora de inicio de sesión
        notifyListeners();
        _logger.d(
            'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
        setMessage('Inicio de sesión exitoso con correo y contraseña');
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

  Future<void> signOut(BuildContext context) async {
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

    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _userService.signOut();
      _currentUser = null;
      _logger.d('Sesión cerrada correctamente');
      setMessage('Sesión cerrada correctamente');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      setMessage('Error al cerrar sesión');
      if (context.mounted) {
        Navigator.pop(context); // Cerrar la ventana de carga si hay un error
      }
    }
  }

  Future<Usuario?> registerUserWithEmailAndPassword(
      Map<String, dynamic> formData) async {
    _logger.d('Datos del formulario desde LoginViewModel: $formData');

    try {
      Usuario? user =
          await _userService.registerUserWithEmailAndPassword(formData);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _logger.d(
            'Usuario registrado correctamente con correo y contraseña: ${user.email}');
        return user;
      } else {
        _logger.w('Registro de usuario fallido con correo y contraseña');
        return null;
      }
    } catch (e) {
      _logger.e('Error al registrar usuario con correo y contraseña: $e');
      return null;
    }
  }
}
