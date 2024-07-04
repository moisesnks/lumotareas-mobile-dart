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
  final int miembros;
  final Owner owner;
  final bool vacantes;
  final List<dynamic> formulario;
  final String descripcion;

  Organization({
    required this.nombre,
    required this.miembros,
    required this.owner,
    required this.vacantes,
    required this.formulario,
    required this.descripcion,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      nombre: map['nombre'] ?? '',
      miembros: map['miembros'] ?? 0,
      owner: Owner.fromMap(Map<String, String>.from(map['owner'] ?? {})),
      vacantes: map['vacantes'] ?? false,
      formulario: map['formulario'] ?? [],
      descripcion: map['descripcion'] ?? '',
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
    };
  }

  @override
  String toString() {
    return 'Organization: $nombre\nOwner: $owner\nMiembros: $miembros\nVacantes: $vacantes\nFormulario: $formulario\nDescripción: $descripcion';
  }
}
