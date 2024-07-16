import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumotareas/lib/models/response.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/services/access_service.dart';
import 'package:lumotareas/lib/services/user_data_service.dart';

class AuthService {
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserDataService _userDataService = UserDataService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      return Response(
        success: false,
        message: 'Error al iniciar sesión con Google: $e',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
