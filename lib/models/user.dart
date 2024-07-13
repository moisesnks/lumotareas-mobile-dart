class OrganizacionInterna {
  final String nombre;
  final String id;
  final bool isOwner;

  OrganizacionInterna({
    required this.nombre,
    required this.id,
    this.isOwner = false,
  });

  factory OrganizacionInterna.fromMap(Map<String, dynamic> map) {
    return OrganizacionInterna(
      nombre: map['nombre'] ?? '',
      id: map['id'] ?? '',
      isOwner: map['isOwner'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'id': id,
      'isOwner': isOwner,
    };
  }

  @override
  String toString() {
    return 'OrganizacionInterna{nombre: $nombre, id: $id, isOwner: $isOwner}';
  }
}

class Solicitud {
  final String id;
  final String organizationId;

  Solicitud({
    required this.id,
    required this.organizationId,
  });

  factory Solicitud.fromMap(String id, Map<String, dynamic> map) {
    return Solicitud(
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
    return 'Solicitud{id: $id, organizationId: $organizationId}';
  }
}

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<OrganizacionInterna>? organizaciones;
  final List<Solicitud>? solicitudes;
  final String photoURL;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    required this.photoURL,
    this.organizaciones,
    this.solicitudes,
  });

  String get getUid => uid;

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      birthdate: map['birthdate'] ?? '',
      photoURL: map['photoURL'] ?? '',
      organizaciones: (map['organizaciones'] as List<dynamic>?)
          ?.map((org) => OrganizacionInterna.fromMap(org))
          .toList(),
      solicitudes: (map['solicitudes'] as List<dynamic>?)
          ?.map((sol) => Solicitud.fromMap(sol['id'], sol))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'photoURL': photoURL,
      'organizaciones': organizaciones?.map((org) => org.toMap()).toList(),
      'solicitudes':
          solicitudes?.map((solicitud) => solicitud.toMap()).toList(),
    };
  }

  List<String> getOwnerOrganizationIds() {
    return organizaciones
            ?.where((org) => org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  List<String> getMemberOrganizationIds() {
    return organizaciones
            ?.where((org) => !org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  bool isOwnerOfOrganization(String organizationId) {
    return organizaciones
            ?.any((org) => org.id == organizationId && org.isOwner) ??
        false;
  }

  @override
  String toString() {
    return 'Usuario{uid: $uid, nombre: $nombre, email: $email, birthdate: $birthdate, organizaciones: $organizaciones, solicitudes: $solicitudes}';
  }
}
