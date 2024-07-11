import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/organization_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final OrganizationService _organizationService = OrganizationService();
  final Logger _logger = Logger();

  // currentUser
  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  // Método para iniciar sesión con Google SignIn
  Future<Usuario?> signInWithGoogle() async {
    try {
      // Iniciar sesión con Google usando AuthService
      User? firebaseUser = await _authService.signInWithGoogle();
      // Busca el uid del usuario en la base de datos

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

  // TODO: borrar estos métodos
  // Método para iniciar sesión con correo y contraseña
  Future<Usuario?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Iniciar sesión con correo y contraseña usando AuthService
      User? firebaseUser =
          await _authService.signInWithEmailPassword(email, password);

      if (firebaseUser != null) {
        // Obtener el JWT del usuario autenticado
        String? idToken = await firebaseUser.getIdToken();

        if (idToken != null) {
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
          _logger
              .w('No se pudo obtener el token JWT después de iniciar sesión');
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

  // Método
  // Registrar la referencia de la solicitud en el usuario, para eso
  // el usuario tiene un campo (array) que se llama solicitudes el cual con el servicio
  // de firestore se usará el método addToArray para agregar la referencia de la solicitud
  // a ese array
  Future<bool> addSolicitudToUser(String uid, String solicitudId) async {
    try {
      // Obtener usuario actual
      Usuario? user = await getUserByUid(uid);

      if (user != null) {
        // Verificar si la solicitud ya existe en las solicitudes del usuario
        if (user.solicitudes!.contains(solicitudId)) {
          _logger.w('La solicitud ya existe en las solicitudes del usuario');
          return true;
        } else {
          // Agregar la nueva solicitud
          user.solicitudes!.add(solicitudId);

          // Actualizar los datos del usuario en Firestore
          await updateUserData(user);

          _logger
              .d('Solicitud agregada al usuario correctamente: $solicitudId');
          return true;
        }
      } else {
        _logger.w('No se encontró al usuario con UID: $uid');
        return false;
      }
    } catch (e) {
      _logger.e('Error al agregar solicitud al usuario: $e');
      return false;
    }
  }

  Future<Usuario?> registerUserWithEmailAndPassword(
    Map<String, dynamic> formData,
  ) async {
    // logger a lo que llegó en el formulario
    _logger.d('Datos del formulario desde user_service: $formData');

    try {
      // Extraer datos del formulario
      String email = formData['email']!;
      String fullName = formData['fullName']!;
      String birthdate = formData['birthDate']!;
      String password = formData['password']!;
      String orgName = formData['orgName'] ?? '';
      bool? isOwner = formData['isOwner'];
      bool isMember = formData['isMember'] ?? false;
      Map<String, dynamic>? formulario = formData['formulario'];

      // logger a lo que llegó en el formulario
      _logger.d(
          'Extracción correcta de todos los datos del formulario: $formData');

      User? firebaseUser =
          await _authService.signUpWithEmailPassword(email, password, fullName);

      String solicitudId = '';
      if (firebaseUser != null) {
        // Enviar la solicitud a la organización
        if (formulario != null && orgName.isNotEmpty) {
          var result = await _organizationService.registerSolicitud(
            orgName,
            formulario,
            firebaseUser.uid,
          );
          _logger.d('Solicitud de organización creada: ${result['ref']}');
          solicitudId = result['ref'];
        } else if (orgName.isEmpty) {
          _logger.w('No se proporcionó un nombre de organización');
          return null;
        }
        // Crear instancia de Usuario con datos del formulario
        Usuario newUser;
        if (orgName.isNotEmpty && isMember) {
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: fullName,
            email: email,
            birthdate: birthdate,
            organizaciones: [
              OrganizacionInterna(
                nombre: orgName,
                id: orgName,
                isOwner: isOwner ?? false,
              ),
            ],
          );
        } else if (orgName.isNotEmpty && !isMember) {
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: fullName,
            email: email,
            birthdate: birthdate,
            solicitudes: [solicitudId],
          );
        } else {
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: fullName,
            email: email,
            birthdate: birthdate,
          );
        }

        // Convertir el objeto Usuario a un mapa para almacenarlo en Firestore
        Map<String, dynamic> userData = newUser.toMap();

        // Añadir documento de usuario a Firestore usando FirestoreService
        Map<String, dynamic> result =
            await _firestoreService.addDocument('users', newUser.uid, userData);

        if (result['success'] == true) {
          _logger.d(
              'Usuario registrado correctamente con correo y contraseña: $email');
          // Agregar la solicitud al usuario
          bool success = await addSolicitudToUser(newUser.uid, solicitudId);
          if (success) {
            return newUser;
          } else {
            _logger.e(
                'Error al agregar referencia de solicitud al usuario: $email');
            return null;
          }
        } else {
          _logger.e(
              'Error al añadir usuario a Firestore después de registrar con correo y contraseña');
          return null;
        }
      } else {
        _logger.w('Inicio de sesión fallido con correo y contraseña');
        return null;
      }
    } catch (e) {
      _logger.e('Error al registrar usuario con correo y contraseña: $e');
      return null;
    }
  }

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
          birthdate: '',
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

  Future<bool> checkIfUserExists(String uid) async {
    try {
      // Obtener documento de usuario de Firestore usando FirestoreService
      Map<String, dynamic> result =
          await _firestoreService.getDocument('users', uid);

      // Verificar si se encontró el usuario
      return result['found'] ?? false;
    } catch (e) {
      _logger.e('Error al verificar si el usuario existe: $e');
      return false;
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
}
