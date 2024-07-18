//Modelo de Solicitud en Firebase
library;

/// Estado de una solicitud.
enum EstadoSolicitud { pendiente, aceptada, rechazada }

/// Clase que representa una solicitud en Firestore.
class Solicitud {
  final String id; // El id de la solicitud
  final EstadoSolicitud estado; // El estado de la solicitud
  final String fecha; // Fecha en la que se hizo la solicitud
  final Map<String, dynamic>
      solicitud; // Es un mapa de la solicitud que llegó, son las preguntas y respuestas
  final String uid; // El uid del usuario que hizo la solicitud
  final String email; // El email del usuario que hizo la solicitud
  final String respuesta; // La respuesta a la solicitud

  /// Constructor para crear una instancia de [Solicitud].
  ///
  /// [id] es el identificador único de la solicitud.
  /// [estado] es el estado de la solicitud.
  /// [fecha] es la fecha en que se hizo la solicitud.
  /// [solicitud] es un mapa con las preguntas y respuestas de la solicitud.
  /// [uid] es el identificador del usuario que hizo la solicitud.
  /// [email] es el correo electrónico del usuario que hizo la solicitud.
  Solicitud({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.solicitud,
    required this.uid,
    required this.email,
    this.respuesta = '',
  });

  /// Crea una instancia de [Solicitud] a partir de un mapa.
  ///
  /// [id] es el identificador único de la solicitud.
  /// [map] es el mapa que contiene los datos de la solicitud.
  factory Solicitud.fromMap(String id, Map<String, dynamic> map) {
    return Solicitud(
      id: id,
      estado: map['estado'] == 'pendiente'
          ? EstadoSolicitud.pendiente
          : map['estado'] == 'aceptada'
              ? EstadoSolicitud.aceptada
              : EstadoSolicitud.rechazada,
      fecha: map['fecha'] ?? '',
      solicitud: map['solicitud'] ?? {},
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      respuesta: map['respuesta'] ?? '',
    );
  }

  /// Convierte una instancia de [Solicitud] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'estado': estado.toString().split('.').last,
      'fecha': fecha,
      'solicitud': solicitud,
      'uid': uid,
      'email': email,
      'respuesta': respuesta,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'Solicitud: $id, Estado: $estado, Fecha: $fecha, Solicitud: $solicitud, UID: $uid';
  }
}
