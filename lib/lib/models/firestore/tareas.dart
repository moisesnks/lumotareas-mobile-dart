//Modelos de Tareas
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'subtarea.dart';
import 'comentarios.dart';
import 'logs.dart';

/// Clase que representa una tarea almacenada en Firestore.
class TareaFirestore {
  final String id;
  final String name;
  final String description;
  final Timestamp startDate;
  final Timestamp endDate;
  final List<Subtarea> subtareas;
  final List<String> asignados;
  List<Comentarios> comentarios = [];
  bool private = false;
  List<Logs> logs = [];
  final String sprintId;
  final String projectId;
  final String createdBy;
  final bool visible = false;

  /// Constructor para crear una instancia de [TareaFirestore].
  ///
  /// [id] es el identificador único de la tarea.
  /// [name] es el nombre de la tarea.
  /// [description] es la descripción de la tarea.
  /// [startDate] es la fecha de inicio de la tarea.
  /// [endDate] es la fecha de finalización de la tarea.
  /// [subtareas] es la lista de subtareas asociadas a la tarea.
  /// [asignados] es la lista de identificadores de los usuarios asignados a la tarea.
  /// [comentarios] es opcional y es la lista de comentarios en la tarea.
  /// [logs] es opcional y es la lista de registros de actividad de la tarea.
  /// [private] es opcional y indica si la tarea es privada.
  /// [sprintId] es el identificador del sprint al que pertenece la tarea.
  /// [projectId] es el identificador del proyecto al que pertenece la tarea.
  /// [createdBy] es el identificador del usuario que creó la tarea.
  /// [visible] es opcional y indica si la tarea es visible.
  TareaFirestore({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.subtareas,
    required this.asignados,
    this.comentarios = const [],
    this.logs = const [],
    bool private = false,
    required this.sprintId,
    required this.projectId,
    required this.createdBy,
    bool visible = false,
  });

  /// Crea una instancia de [TareaFirestore] a partir de un mapa.
  ///
  /// [id] es el identificador único de la tarea.
  /// [map] es el mapa que contiene los datos de la tarea.
  factory TareaFirestore.fromMap(String id, Map<String, dynamic> map) {
    return TareaFirestore(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? Timestamp.now(),
      endDate: map['endDate'] ?? Timestamp.now(),
      subtareas: (map['subtareas'] as List<dynamic>?)
              ?.map((subtarea) => Subtarea.fromMap(subtarea))
              .toList() ??
          [],
      asignados: (map['asignados'] as List<dynamic>?)
              ?.map((asignado) => asignado.toString())
              .toList() ??
          [],
      comentarios: (map['comentarios'] as List<dynamic>?)
              ?.map((comentario) => Comentarios.fromMap(comentario))
              .toList() ??
          [],
      logs: (map['logs'] as List<dynamic>?)
              ?.map((log) => Logs.fromMap(log))
              .toList() ??
          [],
      private: map['private'] ?? false,
      sprintId: map['sprintId'] ?? '',
      projectId: map['projectId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      visible: map['visible'] ?? false,
    );
  }

  /// Convierte una instancia de [TareaFirestore] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'subtareas': subtareas.map((subtarea) => subtarea.toMap()).toList(),
      'asignados': asignados,
      'comentarios':
          comentarios.map((comentario) => comentario.toMap()).toList(),
      'logs': logs.map((log) => log.toMap()).toList(),
      'private': private,
      'sprintId': sprintId,
      'projectId': projectId,
      'createdBy': createdBy,
      'visible': visible,
    };
  }

  /// Obtiene el número total de subtareas.
  int get totalSubtareas => subtareas.length;

  /// Obtiene el número de subtareas completadas.
  int get subtareasCompletadas => subtareas.where((s) => s.done).length;

  /// Obtiene el número de subtareas pendientes.
  int get subtareasPendientes => totalSubtareas - subtareasCompletadas;

  /// Calcula el progreso de la tarea basado en las subtareas completadas.
  double get progress =>
      (totalSubtareas == 0) ? 0 : (subtareasCompletadas / totalSubtareas);

  @override
  String toString() {
    return 'Tarea: $id, Nombre: $name, Descripción: $description, Fecha de Inicio: $startDate, Fecha de Fin: $endDate, Asignados: $asignados, Subtareas: $subtareas, Comentarios: $comentarios, Logs: $logs, Privada: $private, Sprint: $sprintId, Proyecto: $projectId';
  }
}
