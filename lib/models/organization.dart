class Organization {
  final String nombre;
  final int miembros;
  final String owner;
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
      owner: map['owner'] ?? '',
      vacantes: map['vacantes'] ?? false,
      formulario: map['formulario'] ?? [],
      descripcion: map['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'miembros': miembros,
      'owner': owner,
      'vacantes': vacantes,
      'formulario': formulario,
      'descripcion': descripcion,
    };
  }
}
