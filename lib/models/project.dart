/// Representa un proyecto con atributos específicos.
///
/// Un proyecto tiene un identificador único [id], un nombre descriptivo [nombre],
/// una descripción detallada [descripcion] y una lista de miembros asignados [asignados].
class Project {
  final String id;
  final String nombre;
  final String descripcion;
  final List<String> asignados;

  /// Constructor para inicializar un proyecto con los atributos requeridos.
  Project({
    this.id = '',
    required this.nombre,
    required this.descripcion,
    required this.asignados,
  });

  /// Constructor de fábrica que crea un objeto [Project] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos del proyecto.
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      asignados: List<String>.from(map['asignados'] ?? []),
    );
  }

  /// Convierte el objeto [Project] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo del proyecto se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'asignados': asignados,
    };
  }

  /// Sobrescribe el método toString para proporcionar una representación en cadena del objeto [Project].
  @override
  String toString() {
    return 'Project{id: $id, nombre: $nombre, descripcion: $descripcion, asignados: $asignados}';
  }
}
