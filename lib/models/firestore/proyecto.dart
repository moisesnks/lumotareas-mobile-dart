class ProyectoFirestore {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> asignados;
  final List<String> sprints;
  final String orgName;
  final String createdBy;

  ProyectoFirestore({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.asignados,
    required this.sprints,
    required this.orgName,
    required this.createdBy,
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
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'asignados': asignados,
      'sprints': sprints,
      'orgName': orgName,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return 'Proyecto: $id, Nombre: $nombre, Descripción: $descripcion, Asignados: $asignados Sprints: $sprints OrgName: $orgName';
  }
}
