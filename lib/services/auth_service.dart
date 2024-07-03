import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/services/firestore_service.dart';
import 'dart:async';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

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

  Future<User?> signInWithGoogle() async {
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

        if (user != null) {
          final userExists = await checkIfUserExists(user.uid);
          if (userExists) {
            _logger.d(
                'Inicio de sesión exitoso con Google. Usuario: ${user.email}');
            return user;
          } else {
            _logger
                .w('Usuario no existe, no se puede iniciar sesión con Google');
            await deleteUser();
            return null;
          }
        } else {
          _logger.w(
              'No se pudo obtener el usuario después de iniciar sesión con Google.');
        }
      } else {
        _logger.w('El usuario canceló el inicio de sesión con Google.');
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
    }
    return null; // Retornar null si ocurre algún error
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
