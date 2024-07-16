class ProyectoFirestore {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> asignados;
  final List<String> sprints;
  final String orgName;

  ProyectoFirestore({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.asignados,
    required this.sprints,
    required this.orgName,
  });

  factory ProyectoFirestore.fromMap(String id, Map<String, dynamic> map) {
    return ProyectoFirestore(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      asignados: (map['asignados'] as List<dynamic>?)
              ?.map((asignado) => asignado.toString())
              .toList() ??
          [],
      sprints: (map['sprints'] as List<dynamic>?)
              ?.map((sprint) => sprint.toString())
              .toList() ??
          [],
      orgName: map['orgName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'asignados': asignados,
      'sprints': sprints,
      'orgName': orgName,
    };
  }

  @override
  String toString() {
    return 'Proyecto: $id, Nombre: $nombre, Descripción: $descripcion, Asignados: $asignados Sprints: $sprints OrgName: $orgName';
  }
}
