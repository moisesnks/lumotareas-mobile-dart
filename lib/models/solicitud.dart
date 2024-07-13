class SolicitudUser {
  final String id;
  final String organizationId;

  SolicitudUser({
    required this.id,
    required this.organizationId,
  });

  factory SolicitudUser.fromMap(String id, Map<String, dynamic> map) {
    return SolicitudUser(
      id: id,
      organizationId: map['organizationId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
    };
  }

  @override
  String toString() {
    return 'SolicitudUser{id: $id, organizationId: $organizationId}';
  }
}

class SolicitudOrg {
  final String id;
  final String estado;
  final String fecha;
  Map<String, dynamic> solicitud;
  final String uid;
  final String? respuesta;

  SolicitudOrg({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.solicitud,
    required this.uid,
    this.respuesta,
  });

  factory SolicitudOrg.fromMap(String id, Map<String, dynamic> map) {
    return SolicitudOrg(
      id: id,
      estado: map['estado'],
      fecha: map['fecha'],
      solicitud: map['solicitud'],
      uid: map['uid'],
      respuesta: map['respuesta'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estado': estado,
      'fecha': fecha,
      'solicitud': solicitud,
      'uid': uid,
      'respuesta': respuesta,
    };
  }

  @override
  String toString() {
    return 'SolicitudOrg{id: $id, estado: $estado, fecha: $fecha, solicitud: $solicitud, uid: $uid, respuesta: $respuesta}';
  }
}
