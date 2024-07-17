//Servicio de autenticación con Google
library;

import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/access_service.dart';
import 'package:lumotareas/services/user_data_service.dart';

/// Servicio de autenticación que maneja el inicio y cierre de sesión con Google.
class AuthService {
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserDataService _userDataService = UserDataService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Inicia sesión con Google y autentica al usuario en Firebase.
  ///
  /// Devuelve una [Response] con el usuario autenticado o un mensaje de error.
  Future<Response<Usuario>> loginWithGoogle() async {
    try {
      // Inicializa GoogleSignIn
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

      // Intenta iniciar sesión con Google
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        return Response(
          success: false,
          message: 'Inicio de sesión cancelado',
        );
      }

      // Obtén la autenticación de Google
      GoogleSignInAuthentication auth = await account.authentication;
      final String idToken = auth.idToken ?? '';
      final String accessToken = auth.accessToken ?? '';

      if (idToken.isEmpty || accessToken.isEmpty) {
        return Response(
          success: false,
          message: 'Error al obtener tokens de Google',
        );
      }

      // Crea las credenciales de autenticación
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Intenta registrar al usuario en Firebase Auth
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return Response(
          success: false,
          message: 'Error al iniciar sesión con Google',
        );
      }

      _logger.d(
          'Inicio de sesión con Google exitoso. Usuario: ${firebaseUser.email}');

      // Verifica si el usuario existe en la base de datos
      Response<Usuario> response = await _userDataService.getData(firebaseUser);
      if (!response.success) {
        _auth.signOut();
        _googleSignIn.signOut();

        return Response(
          success: false,
          message: 'Error al obtener datos del usuario',
        );
      }

      // Accede al servicio para marcar el acceso del usuario
      await AccessService.access(idToken);

      // Devuelve el usuario
      return Response(
        success: true,
        data: response.data,
        message: 'Inicio de sesión exitoso',
      );
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      _auth.signOut();
      _googleSignIn.signOut();
      return Response(
        success: false,
        message: 'Error al iniciar sesión con Google: $e',
      );
    }
  }

  Future<Response<Usuario>> registerWithGoogle({String birthDate = ''}) async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

    try {
      // Intenta iniciar sesión con Google
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        return Response(
          success: false,
          message: 'Inicio de sesión cancelado',
        );
      }
      GoogleSignInAuthentication auth = await account.authentication;
      final String idToken = auth.idToken ?? '';
      final String accessToken = auth.accessToken ?? '';

      if (idToken.isEmpty || accessToken.isEmpty) {
        return Response(
          success: false,
          message: 'Error al obtener tokens de Google',
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      // Intenta registrar al usuario en Firebase Auth
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return Response(
          success: false,
          message: 'Error al iniciar sesión con Google',
        );
      }

      _logger.d(
          'Inicio de sesión con Google exitoso. Usuario: ${firebaseUser.email}');

      // Verifica si el usuario existe en la base de datos
      Response<Usuario> response = await _userDataService.getData(firebaseUser);

      // si el usuario existe, retorna que ya existe
      if (response.success) {
        return Response(
          success: false,
          message: 'El usuario ya existe',
        );
      }

      // si el usuario no existe, lo crea
      response =
          await _userDataService.create(firebaseUser, birthDate: birthDate);

      if (response.success) {
        return Response(
          success: true,
          data: response.data,
          message: 'Usuario creado exitosamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al crear usuario',
        );
      }
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      _auth.signOut();
      _googleSignIn.signOut();
      return Response(
        success: false,
        message: 'Error al iniciar sesión con Google: $e',
      );
    }
  }

  /// Cierra la sesión del usuario.
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
