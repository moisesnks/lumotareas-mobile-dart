import '../sprint/sprint.dart';
import '../firestore/proyecto.dart';

class Proyecto {
  ProyectoFirestore proyecto;
  List<Sprint> sprints;

  Proyecto({
    required this.proyecto,
    required this.sprints,
  });

  factory Proyecto.fromMap(String id, Map<String, dynamic> map) {
    return Proyecto(
      proyecto: ProyectoFirestore.fromMap(id, map['proyecto']),
      sprints: (map['sprints'] as List<dynamic>?)
              ?.map((sprint) => Sprint.fromMap(sprint))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'proyecto': proyecto.toMap(),
      'sprints': sprints.map((sprint) => sprint.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Proyecto: $proyecto,Sprints: $sprints';
  }
}
