//Modelos de Comentarios
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'small_user.dart';

/// Clase que representa un comentario en una tarea.
class Comentarios {
  final String message;
  final SmallUser user;
  final Timestamp fecha;

  /// Constructor para crear una instancia de [Comentarios].
  ///
  /// [message] es el mensaje del comentario.
  /// [user] es la instancia de [SmallUser] que realizó el comentario.
  /// [fecha] es la marca de tiempo del comentario.
  Comentarios({
    required this.message,
    required this.user,
    required this.fecha,
  });

  /// Crea una instancia de [Comentarios] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos del comentario.
  factory Comentarios.fromMap(Map<String, dynamic> map) {
    return Comentarios(
      message: map['message'] ?? '',
      user: SmallUser.fromMap(map['user'] ?? {}),
      fecha: map['fecha'] ?? Timestamp.now(),
    );
  }

  /// Convierte una instancia de [Comentarios] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'user': user.toMap(),
      'fecha': fecha,
    };
  }

  @override
  String toString() {
    return 'Comentario: Mensaje: $message, Usuario: $user, Fecha: $fecha';
  }
}
