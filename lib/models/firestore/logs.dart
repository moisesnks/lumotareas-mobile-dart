//Modelos de registro de actividad (log)
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase que representa un registro de actividad (log).
class Logs {
  final String uid;
  final String message;
  final Timestamp timestamp;

  /// Constructor para crear una instancia de [Logs].
  ///
  /// [uid] es el identificador del usuario que generó el log.
  /// [message] es el mensaje del log.
  /// [timestamp] es la marca de tiempo del log.
  Logs({
    required this.uid,
    required this.message,
    required this.timestamp,
  });

  /// Crea una instancia de [Logs] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos del log.
  factory Logs.fromMap(Map<String, dynamic> map) {
    return Logs(
      uid: map['uid'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  /// Convierte una instancia de [Logs] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'message': message,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'Log: UID: $uid, Mensaje: $message, Fecha: $timestamp';
  }
}
