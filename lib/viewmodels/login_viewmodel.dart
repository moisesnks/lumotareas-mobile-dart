import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/screens/welcome_screen/nueva_org/creando_org/creando_org_screen.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:lumotareas/services/rest_service.dart';
import 'package:lumotareas/models/register_form.dart';
import 'package:lumotareas/models/organization.dart';

class LoginViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  String? _message;

  String? get message => _message;

  final List<Map<String, dynamic>> _history = [];

  bool loading = false;

  // Getter usa el fetchUserHistory
  List<Map<String, dynamic>> get history {
    if (_currentUser != null && _history.isEmpty) {
      fetchUserHistory(_currentUser!.email);
    }
    return _history;
  }

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  String? readMessage() {
    final message = _message;
    _message = null;
    return message;
  }

  Future<void> createOrganization(
      BuildContext context, Organization organization) async {
    Usuario? user = await _userService.createOrganization(organization);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      _logger.d('Organización creada y asignada al usuario correctamente');
      setMessage('Organización creada y asignada al usuario correctamente');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    } else {
      _logger.e('Error al crear la organización');
      setMessage('Error al crear la organización');
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> fetchUserHistory(String email) async {
    loading = true;
    try {
      List<Map<String, dynamic>> logs = await RestService.all(email);
      _history.clear();
      _history.addAll(logs);
      notifyListeners();
      _logger.d('Historial de usuario obtenido correctamente. $logs');
      loading = false;
    } catch (e) {
      _logger.e('Error al obtener historial de usuario: $e');
    }
  }

  // Método para registrarse con Google
  Future<void> signUpWithGoogle(BuildContext context, RegisterForm form) async {
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
              Text('Registrando con Google...'),
            ],
          ),
        ),
      );
    }));

    try {
      Usuario? user = await _userService.signUpWithGoogle(form);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _logger.d('Registro exitoso con Google: ${user.email}');
        setMessage('Registro exitoso con Google');
        // Navegar a '/main' y reemplazar todas las rutas anteriores
        if (context.mounted) {
          if (form.respuestas != null || form.orgName.isEmpty) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false);
          } else if (form.orgName.isNotEmpty && form.respuestas == null) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return CreandoOrgScreen(
                    orgName: form.orgName, ownerUID: _currentUser!.uid);
              },
            ));
          }
        }
      } else {
        _logger.w('Registro fallido con Google');
        setMessage('Registro fallido con Google, usuario no encontrado');
        if (context.mounted) {
          Navigator.pop(context);
          // Mostrar un snackbar con 'El usuario no existe en la base de datos'
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'El usuario ya existe, o ha ocurrido un error mientras se registraba con Google'),
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Error al registrar con Google: $e');
      setMessage('Error al registrar con Google');
    }
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
          // Mostrar un snackbar con 'El usuario no existe en la base de datos'
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'El usuario no existe, o ha ocurrido un error mientras se iniciaba sesión con Google'),
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      setMessage('Error al iniciar sesión con Google');
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
      _history.clear();
      _logger.d('Sesión cerrada correctamente');
      setMessage('Sesión cerrada correctamente');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      setMessage('Error al cerrar sesión');
    }
  }
}
