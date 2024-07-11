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

  // Instancia de GoogleSignIn con los scopes necesarios
  static final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['email', 'profile']);

  Future<User?> signInWithGoogle() async {
    try {
      // Intenta iniciar sesión con Google
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        final String idToken = auth.idToken ?? '';
        final String accessToken = auth.accessToken ?? '';

        if (idToken.isNotEmpty && accessToken.isNotEmpty) {
          // Guarda la información de autenticación en el servicio REST
          RestService.access(idToken);

          // Crea las credenciales de autenticación
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: accessToken,
          );

          // Inicia sesión en Firebase Auth
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            _logger.d(
                'Inicio de sesión con Google exitoso. Usuario: ${user.email}');
            return user;
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
    }
    return null;
  }

//metodo getcurrentuser:
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el nombre del usuario y darle foto con ui-avatar
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!
          .updatePhotoURL('https://ui-avatars.com/api/?name=$name');

      final User? user = userCredential.user;

      _logger.d('Registro exitoso. Usuario: ${user?.email}');
      return user;
    } catch (e) {
      _logger.e('Error al registrar con correo y contraseña: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      _logger.d('Inicio de sesión exitoso. Usuario: ${user?.email}');
      return user;
    } catch (e) {
      _logger.e('Error al iniciar sesión con correo y contraseña: $e');
      return null;
    }
  }

  Future<User?> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        _logger.d('Registro exitoso con Google. Usuario: ${user?.email}');
        return user;
      } else {
        _logger.w('El usuario canceló el registro con Google.');
      }
    } catch (e) {
      _logger.e('Error al registrar con Google: $e');
    }

    return null; // Retornar null si ocurre algún error
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
