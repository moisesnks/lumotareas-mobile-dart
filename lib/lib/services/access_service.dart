import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AccessService {
  static const String _mime = 'application/json';
  static const String _baseUrl = 'https://api.sebastian.cl/Auth';
  static const Map<String, String> _headers = {
    'accept': _mime,
    'X-API-TOKEN': 'sebastian.cl',
    'X-API-KEY': 'aaa-bbb-ccc-ddd',
    'Content-Type': _mime,
  };

  static final Logger _logger = Logger();

  // Método para manejar respuestas HTTP
  static void _handleResponse(http.Response response) {
    final int status = response.statusCode;
    final String jsonResponse = response.body;

    if (status >= 200 && status < 300) {
      _logger.i('Respuesta correcta con código $status');
    } else {
      _logger.e('Respuesta incorrecta con código $status');
      _logger.e(jsonResponse);
    }
  }

  // Método de acceso POST para marcar la entrada
  static Future<void> access(String idToken) async {
    _logger.i('Acceso con idToken: $idToken');
    try {
      const String url = '$_baseUrl/v1/access/login';

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode({'jwt': idToken}),
      );

      _handleResponse(response);
    } catch (error, stacktrace) {
      _logger.e(error.toString());
      _logger.e(stacktrace.toString());
    }
  }

  // Método para obtener los registros de sesión
  static Future<List<Map<String, dynamic>>> all(String email) async {
    List<Map<String, dynamic>> logs = [];
    try {
      _logger.d('Obteniendo registros de: $email');
      const String url = '$_baseUrl/v1/access/all';

      final response = await http.get(
        Uri.parse(url).replace(queryParameters: {'email': email}),
        headers: _headers,
      );

      _handleResponse(response);

      if (response.statusCode == 200) {
        logs = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (error, stacktrace) {
      _logger.e(error.toString());
      _logger.e(stacktrace.toString());
    }
    return logs;
  }
}