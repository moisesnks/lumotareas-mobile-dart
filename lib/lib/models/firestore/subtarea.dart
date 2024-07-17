// Modelo de Subtarea
library;

/// Clase que representa una subtarea dentro de una tarea.
class Subtarea {
  final String id;
  final String name;
  final String description;
  bool done;
  String completedBy;

  /// Constructor para crear una instancia de [Subtarea].
  ///
  /// [id] es el identificador único de la subtarea.
  /// [name] es el nombre de la subtarea.
  /// [description] es la descripción de la subtarea.
  /// [done] indica si la subtarea está completada.
  /// [completedBy] es opcional y es el identificador del usuario que completó la subtarea.
  Subtarea({
    required this.id,
    required this.name,
    required this.description,
    required this.done,
    this.completedBy = '',
  });

  /// Crea una instancia de [Subtarea] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos de la subtarea.
  factory Subtarea.fromMap(Map<String, dynamic> map) {
    return Subtarea(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      done: map['done'] ?? false,
      completedBy: map['completedBy'] ?? '',
    );
  }

  /// Convierte una instancia de [Subtarea] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'done': done,
      'completedBy': completedBy,
    };
  }

  @override
  String toString() {
    return 'Subtarea: Id: $id, Nombre: $name, Descripción: $description, Hecho: $done por $completedBy';
  }
}
