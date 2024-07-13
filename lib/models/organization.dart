class Owner {
  final String nombre;
  final String uid;

  Owner({
    required this.nombre,
    required this.uid,
  });

  factory Owner.fromMap(Map<String, String> map) {
    return Owner(
      nombre: map['nombre'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'nombre': nombre,
      'uid': uid,
    };
  }

  @override
  String toString() {
    return nombre;
  }
}

class Organization {
  final String nombre;
  final List<String> miembros;
  final Owner owner;
  final bool vacantes;
  final Map<String, dynamic> formulario;
  final String descripcion;
  final String imageUrl;
  final List<String> likes;
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

  @override
  String toString() {
    return 'Organization: $nombre\nOwner: $owner\nMiembros: $miembros\nVacantes: $vacantes\nFormulario: $formulario\nDescripción: $descripcion \n Imagen: $imageUrl';
  }
}
