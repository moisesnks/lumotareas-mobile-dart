import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/register_form.dart';
import 'package:lumotareas/models/organization.dart';

class UserService {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final OrganizationService _organizationService = OrganizationService();
  final Logger _logger = Logger();

  // currentUser
  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  // Crea una organización y se la asigna al usuario
  Future<Usuario?> createOrganization(Organization organization) async {
    Map<String, dynamic> result =
        await _organizationService.createOrganization(organization);
    if (result['success']) {
      // Obtener el usuario actual
      Usuario? user = await getUserByUid(_currentUser!.uid);
      if (user != null) {
        // Agregar la organización al usuario
        user.organizaciones!.add(OrganizacionInterna(
          nombre: organization.nombre,
          id: result['ref'],
          isOwner: true,
        ));
        // Actualizar los datos del usuario en Firestore
        await updateUserData(user);
        _logger.d('Organización creada y asignada al usuario correctamente');
        return user;
      } else {
        _logger.w('No se encontró al usuario actual');
        return null;
      }
    } else {
      _logger.e('Error al crear la organización');
      return null;
    }
  }

  // Método para registrar con Google llamando al Auth
  Future<Usuario?> signUpWithGoogle(RegisterForm form) async {
    try {
      // Intentar el registro con el AuthService
      User? firebaseUser = await _authService.signUpWithGoogle();
      String solicitudId = '';
      if (firebaseUser != null) {
        // Enviar la solicitud a la organización
        if (form.respuestas != null && form.orgName.isNotEmpty) {
          // Esperar la solicitud
          Map<String, dynamic> result =
              await _organizationService.registerSolicitud(
            form.orgName,
            form.respuestas!,
            firebaseUser.uid,
          );
          _logger.d('Solicitud enviada a la organización: ${form.orgName}');
          _logger.i('Referencia de la solicitud: ${result['ref']}');
          solicitudId = result['ref'];
        } else if (form.orgName.isEmpty) {
          _logger.w('No se proporcionó el nombre de la organización');
        }
        // Crear una instancia de Usuario con los datos entregados por el formulario
        // y usando también de Google, como el email y el uid.
        Usuario newUser;
        if (form.orgName.isNotEmpty && !form.isOwner) {
          // Se le agrega a la solicitud
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            birthdate: form.birthDate,
            photoURL: firebaseUser.photoURL ?? '',
            solicitudes: [solicitudId],
          );
        } else if (form.orgName.isNotEmpty && form.isOwner) {
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            birthdate: form.birthDate,
            photoURL: firebaseUser.photoURL ?? '',
            organizaciones: [
              OrganizacionInterna(
                nombre: form.orgName,
                id: form.orgName,
                isOwner: form.isOwner,
              )
            ],
          );
        } else if (solicitudId.isEmpty) {
          newUser = Usuario(
            uid: firebaseUser.uid,
            nombre: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            birthdate: form.birthDate,
            photoURL: firebaseUser.photoURL ?? '',
          );
        } else {
          _logger.w('No se pudo crear el usuario');
          return null;
        }
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
      }
    } catch (e) {
      _logger.e('Error al registrar con Google: $e');
      return null;
    }
    return null;
  }

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

  // Método para obtener información de usuario por UID
  Future<Usuario?> getUserByUid(String uid) async {
    _logger.d('Obteniendo información de usuario por UID: $uid');
    try {
      // Obtener documento de usuario de Firestore usando FirestoreService
      Map<String, dynamic> result =
          await _firestoreService.getDocument('users', uid);

      if (result['found'] == true) {
        _logger.d('Usuario encontrado en Firestore con UID: $uid');
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
