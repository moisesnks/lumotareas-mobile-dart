//la clase project tiene:
//id string
//nombre string
//descripcion string
//asignados list<string>

class Project {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> asignados;

  Project({
    this.id = '',
    required this.nombre,
    required this.descripcion,
    required this.asignados,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      asignados: List<String>.from(map['asignados'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'asignados': asignados,
    };
  }

  @override
  String toString() {
    return 'Project{id: $id, nombre: $nombre, descripcion: $descripcion, asignados: $asignados}';
  }
}
