/// Representa una organización interna con atributos específicos.
///
/// Una organización interna tiene un [nombre], un [id] único y un indicador opcional de si el usuario es [isOwner] de la organización.
class OrganizacionInterna {
  final String nombre;
  final String id;
  final bool isOwner;

  /// Constructor para inicializar una organización interna con los atributos requeridos y opcionales.
  OrganizacionInterna({
    required this.nombre,
    required this.id,
    this.isOwner = false,
  });

  /// Constructor de fábrica que crea un objeto [OrganizacionInterna] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la organización interna.
  factory OrganizacionInterna.fromMap(Map<String, dynamic> map) {
    return OrganizacionInterna(
      nombre: map['nombre'] ?? '',
      id: map['id'] ?? '',
      isOwner: map['isOwner'] ?? false,
    );
  }

  /// Convierte el objeto [OrganizacionInterna] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la organización interna se convierte en una entrada en el mapa.
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

/// Representa un usuario con atributos específicos.
///
/// Un usuario tiene un identificador único [uid], un [nombre], un [email], una [birthdate] (fecha de nacimiento),
/// una lista de [organizaciones] internas donde participa, una lista de [solicitudes] pendientes y una URL de [photoURL] opcional.
class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<OrganizacionInterna>? organizaciones;
  final List<String>? solicitudes;
  final String photoURL;

  /// Constructor para inicializar un usuario con los atributos requeridos y opcionales.
  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    required this.photoURL,
    this.organizaciones,
    this.solicitudes,
  });

  /// Getter para obtener el UID del usuario.
  String get getUid => uid;

  /// Constructor de fábrica que crea un objeto [Usuario] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos del usuario.
  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'],
      email: map['email'],
      birthdate: map['birthdate'],
      photoURL: map['photoURL'],
      organizaciones: map['organizaciones'] != null
          ? List<OrganizacionInterna>.from(
              map['organizaciones'].map((org) =>
                  OrganizacionInterna.fromMap(Map<String, dynamic>.from(org))),
            )
          : [],
      solicitudes: map['solicitudes'] != null
          ? List<String>.from(map['solicitudes'])
          : [],
    );
  }

  /// Convierte el objeto [Usuario] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo del usuario se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'photoURL': photoURL,
      'organizaciones': organizaciones?.map((org) => org.toMap()).toList(),
      'solicitudes': solicitudes,
    };
  }

  /// Método para obtener todos los IDs de las organizaciones donde el usuario es dueño.
  List<String> getOwnerOrganizationIds() {
    return organizaciones
            ?.where((org) => org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  /// Método para obtener todos los IDs de las organizaciones donde el usuario es miembro.
  List<String> getMemberOrganizationIds() {
    return organizaciones
            ?.where((org) => !org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  /// Método para verificar si el usuario es dueño de una organización específica identificada por [organizationId].
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
