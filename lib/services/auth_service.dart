import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/services/firestore_service.dart';
import 'package:lumotareas/services/rest_service.dart';
import 'dart:async';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

  //metodo getcurrentuser:
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signUpWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

    try {
      // Intenta iniciar sesión con Google
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        final String idToken = auth.idToken ?? '';
        final String accessToken = auth.accessToken ?? '';

        if (idToken.isNotEmpty && accessToken.isNotEmpty) {
          // Crea las credenciales de autenticación
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: accessToken,
          );

          // Intenta registrar al usuario en Firebase Auth
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            _logger.d('Registro con Google exitoso. Usuario: ${user.email}');

            // Accede al servicio REST en el registro
            RestService.access(idToken);

            // Verifica si existe en la base de datos
            final bool userExists = await checkIfUserExists(user.uid);

            // Si el usuario existe en la base de datos, no se debería registrar denuevo
            // por lo tanto, return null
            if (userExists) {
              _logger.i('Bienvenido de nuevo, ${user.email}!');
              return null;
            }

            // Setea la foto de perfil del usuario, es una foto predeterminada usando ui-avatars.com
            await user.updateProfile(
              photoURL:
                  'https://ui-avatars.com/api/?name=${user.displayName}&background=random&size=128&rounded=true',
            );

            return user;
          } else {
            _logger.w(
                'No se pudo obtener el usuario después del registro con Google.');
          }
        } else {
          _logger.w('No se pudo obtener el token de Google.');
        }
      } else {
        _logger.w('El usuario canceló el registro con Google.');
      }
    } catch (e) {
      _logger.e('Error al registrar con Google: $e');
    } finally {
      // Limpiar instancia de GoogleSignIn para permitir un nuevo intento
      googleSignIn.disconnect();
    }

    return null;
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

    try {
      // Intenta iniciar sesión con Google
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        final String idToken = auth.idToken ?? '';
        final String accessToken = auth.accessToken ?? '';

        if (idToken.isNotEmpty && accessToken.isNotEmpty) {
          // Guarda la información de autenticación en el servicio REST

          // Crea las credenciales de autenticación
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: accessToken,
          );

          // Inicia sesión en Firebase Auth
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            _logger.d(
                'Inicio de sesión con Google exitoso. Usuario: ${user.email}');

            // Verifica si existe en la base de datos
            final bool userExists = await checkIfUserExists(user.uid);
            if (userExists) {
              _logger.i('Bienvenido de nuevo, ${user.email}!');
              // Accede al servicio REST para obtener la información del usuario
              RestService.access(idToken);
              // Si no tiene foto de perfil, se le asigna una predeterminada
              if (user.photoURL == null) {
                await user.updateProfile(
                  photoURL:
                      'https://ui-avatars.com/api/?name=${user.displayName}&background=random&size=128&rounded=true',
                );
              }
              return user;
            } else {
              _logger.e('Este usuario no figura en la base de datos.');
              // Eliminar el usuario de Firebase Auth
              deleteUser();
              _logger.e('Usuario eliminado de Firebase Auth.');
            }
          } else {
            _logger.w(
                'No se pudo obtener el usuario después de iniciar sesión con Google.');
          }
        } else {
          _logger.w('No se pudo obtener el token de Google.');
        }
      } else {
        _logger.w('El usuario canceló el inicio de sesión con Google.');
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
    } finally {
      // Limpiar instancia de GoogleSignIn para permitir un nuevo intento
      googleSignIn.disconnect();
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _logger.d('Sesión cerrada correctamente.');
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
    }
  }

  Future<void> deleteUser() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        _logger.d('Usuario eliminado correctamente.');
      } else {
        _logger.w('No se pudo eliminar el usuario, usuario nulo.');
      }
    } catch (e) {
      _logger.e('Error al eliminar usuario: $e');
    }
  }

  Future<bool> checkIfUserExists(String uid) async {
    // busca en la base de datos si el usuario existe
    final result = await _firestoreService.getDocument('users', uid);
    return result['found'];
  }
}
