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

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<OrganizacionInterna>? organizaciones;
  final List<dynamic>? solicitudes;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    this.organizaciones,
    this.solicitudes,
  });

  String get getUid => uid;

  // Método para convertir un mapa en una instancia de Usuario
  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'],
      email: map['email'],
      birthdate: map['birthdate'],
      organizaciones: map['organizaciones'] != null
          ? List<OrganizacionInterna>.from(
              map['organizaciones'].map((org) =>
                  OrganizacionInterna.fromMap(Map<String, dynamic>.from(org))),
            )
          : [],
      solicitudes: map['solicitudes'] != null
          ? List<dynamic>.from(map['solicitudes'])
          : [],
    );
  }

  // Método para convertir una instancia de Usuario en un mapa
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'organizaciones': organizaciones?.map((org) => org.toMap()).toList(),
      'solicitudes': solicitudes,
    };
  }

  // Método para obtener todos las IDs de las organizaciones donde el usuario es dueño
  List<String> getOwnerOrganizationIds() {
    return organizaciones
            ?.where((org) => org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  // Método para obtener todos las IDs de las organizaciones donde el usuario es miembro
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
