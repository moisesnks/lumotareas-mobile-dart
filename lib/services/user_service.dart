import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'package:lumotareas/models/user.dart';

class UserService {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final Logger _logger = Logger();

  // Método para iniciar sesión con Google SignIn
  Future<Usuario?> signInWithGoogle() async {
    try {
      // Iniciar sesión con Google usando AuthService
      User? firebaseUser = await _authService.signInWithGoogle();

      if (firebaseUser != null) {
        // Obtener información de usuario por UID
        Usuario? user = await getUserByUid(firebaseUser.uid);

        if (user != null) {
          _logger.d('Inicio de sesión exitoso con Google: ${user.email}');
          return user;
        } else {
          _logger.w(
              'Error al obtener información de usuario después de iniciar sesión con Google');
          return null;
        }
      } else {
        _logger.w('Inicio de sesión fallido con Google');
        return null;
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión con AuthService
      await _authService.signOut();
      _logger.d('Sesión cerrada correctamente');
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
    }
  }

  // Método para iniciar sesión con correo y contraseña
  Future<Usuario?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Iniciar sesión con correo y contraseña usando AuthService
      User? firebaseUser =
          await _authService.signInWithEmailPassword(email, password);

      if (firebaseUser != null) {
        // Obtener información de usuario por UID
        Usuario? user = await getUserByUid(firebaseUser.uid);

        if (user != null) {
          _logger.d(
              'Inicio de sesión exitoso con correo y contraseña: ${user.email}');
          return user;
        } else {
          _logger.w(
              'Error al obtener información de usuario después de iniciar sesión con correo y contraseña');
          return null;
        }
      } else {
        _logger.w('Inicio de sesión fallido con correo y contraseña');
        return null;
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con correo y contraseña: $e');
      return null;
    }
  }

  // Método para registrar un usuario con correo y contraseña (en Auth) y Firestore a través de un formulario, en él viene
  //

  // Método para registrar un usuario utilizando Google SignIn
  Future<Usuario?> registerUserWithGoogle() async {
    try {
      // Iniciar sesión con Google usando AuthService
      User? firebaseUser = await _authService.registerWithGoogle();

      if (firebaseUser != null) {
        // Crear instancia de Usuario con datos mínimos
        Usuario newUser = Usuario(
          uid: firebaseUser.uid,
          nombre: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          password: '', // No almacenamos la contraseña en el modelo Usuario
          birthdate:
              '', // Puedes definir la fecha de nacimiento aquí si es necesario
          formulario: null,
          organizaciones: [],
        );

        // Convertir el objeto Usuario a un mapa para almacenarlo en Firestore
        Map<String, dynamic> userData = newUser.toMap();

        // Añadir documento de usuario a Firestore usando FirestoreService
        Map<String, dynamic> result =
            await _firestoreService.addDocument('users', newUser.uid, userData);

        if (result['success'] == true) {
          _logger.d(
              'Usuario registrado correctamente con Google: ${firebaseUser.email}');
          return newUser;
        } else {
          _logger.e(
              'Error al añadir usuario a Firestore después de registrar con Google');
          return null;
        }
      } else {
        _logger.w('El usuario no fue registrado con Google');
        return null;
      }
    } catch (e) {
      _logger.e('Error al registrar usuario con Google: $e');
      return null;
    }
  }

  // Método para obtener información de usuario por UID
  Future<Usuario?> getUserByUid(String uid) async {
    try {
      // Obtener documento de usuario de Firestore usando FirestoreService
      Map<String, dynamic> result =
          await _firestoreService.getDocument('users', uid);

      if (result['found'] == true) {
        // Convertir el mapa obtenido de Firestore a una instancia de Usuario
        Usuario user = Usuario.fromMap(uid, result['data']);
        _logger.d('Usuario encontrado en Firestore con UID: $uid');
        return user;
      } else {
        _logger.w('Usuario no encontrado en Firestore con UID: $uid');
        return null;
      }
    } catch (e) {
      _logger.e('Error al obtener usuario por UID: $uid, error: $e');
      return null;
    }
  }

  // Método para actualizar información de usuario
  Future<bool> updateUserData(Usuario user) async {
    try {
      // Convertir el objeto Usuario a un mapa para actualizar en Firestore
      Map<String, dynamic> newData = user.toMap();

      // Actualizar documento de usuario en Firestore usando FirestoreService
      await _firestoreService.updateDocument('users', user.uid, newData);
      _logger.d(
          'Información de usuario actualizada correctamente para UID: ${user.uid}');
      return true;
    } catch (e) {
      _logger.e(
          'Error al actualizar información de usuario para UID: ${user.uid}, error: $e');
      return false;
    }
  }

  // Método para eliminar usuario
  Future<bool> deleteUserData(String uid) async {
    try {
      // Eliminar documento de usuario en Firestore usando FirestoreService
      await _firestoreService.deleteDocument('users', uid);
      _logger.d('Usuario eliminado correctamente para UID: $uid');
      return true;
    } catch (e) {
      _logger.e('Error al eliminar usuario para UID: $uid, error: $e');
      return false;
    }
  }

  // Método para agregar una organización a las existentes del usuario
  Future<bool> addOrganizationToUser(String uid, String organizationId) async {
    try {
      // Obtener usuario actual
      Usuario? user = await getUserByUid(uid);

      if (user != null) {
        // Verificar si la organización ya existe en las organizaciones del usuario
        if (user.organizaciones!.contains(organizationId)) {
          // La organización ya existe, no es necesario hacer cambios
          return true;
        } else {
          // Agregar la nueva organización
          user.organizaciones!.add(organizationId);

          // Actualizar los datos del usuario en Firestore
          await updateUserData(user);

          _logger.d(
              'Organización agregada al usuario correctamente: $organizationId');
          return true;
        }
      } else {
        _logger.w('No se encontró al usuario con UID: $uid');
        return false;
      }
    } catch (e) {
      _logger.e('Error al agregar organización al usuario: $e');
      return false;
    }
  }
}
