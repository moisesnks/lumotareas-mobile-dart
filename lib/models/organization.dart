class OrganizacionUser {
  final String nombre;
  final String id;
  final bool isOwner;

  OrganizacionUser({
    required this.nombre,
    required this.id,
    this.isOwner = false,
  });

  factory OrganizacionUser.fromMap(Map<String, dynamic> map) {
    return OrganizacionUser(
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
    return 'OrganizacionUser{nombre: $nombre, id: $id, isOwner: $isOwner}';
  }
}

/// Representa un propietario con atributos de nombre y UID.
///
/// Un propietario tiene un [nombre] y un identificador único [uid].
class Owner {
  final String nombre;
  final String uid;

  /// Constructor para inicializar un propietario con los atributos requeridos.
  Owner({
    required this.nombre,
    required this.uid,
  });

  /// Constructor de fábrica que crea un objeto [Owner] a partir de un mapa [Map<String, String>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos del propietario.
  factory Owner.fromMap(Map<String, String> map) {
    return Owner(
      nombre: map['nombre'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  /// Convierte el objeto [Owner] en un mapa [Map<String, String>].
  ///
  /// Cada atributo del propietario se convierte en una entrada en el mapa.
  Map<String, String> toMap() {
    return {
      'nombre': nombre,
      'uid': uid,
    };
  }

  /// Sobrescribe el método toString para proporcionar una representación en cadena del nombre del propietario.
  @override
  String toString() {
    return nombre;
  }
}

/// Representa una organización con atributos específicos.
///
/// Una organización tiene un [nombre], una lista de miembros [miembros],
/// un propietario [owner], un estado de vacantes [vacantes], un formulario [formulario],
/// una descripción [descripcion], una URL de imagen [imageUrl] y una lista de likes [likes].
class Organization {
  final String nombre;
  final List<String> miembros;
  final Owner owner;
  final bool vacantes;
  final Map<String, dynamic> formulario;
  final String descripcion;
  final String imageUrl;
  final List<String> likes;

  /// Constructor para inicializar una organización con los atributos requeridos.
  Organization({
    required this.nombre,
    required this.miembros,
    required this.owner,
    required this.vacantes,
    required this.formulario,
    required this.descripcion,
    this.imageUrl = 'assets/organization_logo.png',
    this.likes = const [],
  });

  /// Constructor de fábrica que crea un objeto [Organization] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la organización.
  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      nombre: map['nombre'] ?? '',
      miembros: List<String>.from(map['miembros'] ?? []),
      owner: Owner.fromMap(Map<String, String>.from(map['owner'] ?? {})),
      vacantes: map['vacantes'] ?? false,
      formulario: map['formulario'] ?? {},
      descripcion: map['descripcion'] ?? '',
      imageUrl: map['imageUrl'] ?? 'assets/organization_logo.png',
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  /// Convierte el objeto [Organization] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la organización se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'miembros': miembros,
      'owner': owner.toMap(),
      'vacantes': vacantes,
      'formulario': formulario,
      'descripcion': descripcion,
      'imageUrl': imageUrl,
      'likes': likes,
    };
  }

  /// Sobrescribe el método toString para proporcionar una representación en cadena detallada de la organización.
  @override
  String toString() {
    return 'Organization: $nombre\nOwner: $owner\nMiembros: $miembros\nVacantes: $vacantes\nFormulario: $formulario\nDescripción: $descripcion\nImagen: $imageUrl';
  }
}
