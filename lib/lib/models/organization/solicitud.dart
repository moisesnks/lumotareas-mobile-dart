enum EstadoSolicitud { pendiente, aceptada, rechazada }

class Solicitud {
  final String id; // El id de la solicitud
  final EstadoSolicitud estado; // El estado de la solicitud
  final String fecha; // Fecha en la que se hizo la solicitud
  final Map<String, dynamic>
      solicitud; // Es un mapa de la solicitud que llegó, son las preguntas y respuestas
  final String uid; // El uid del usuario que hizo la solicitud

  Solicitud({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.solicitud,
    required this.uid,
  });

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'estado': estado.toString().split('.').last,
      'fecha': fecha,
      'solicitud': solicitud,
      'uid': uid,
    };
  }

  @override
  String toString() {
    return 'Solicitud: $id, Estado: $estado, Fecha: $fecha, Solicitud: $solicitud, UID: $uid';
  }
}
