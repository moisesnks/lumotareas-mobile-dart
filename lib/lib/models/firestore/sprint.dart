//Modelo de Sprint en Firestore
library;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase que representa un sprint almacenado en Firestore.
class SprintFirestore {
  final String id;
  final String name;
  final String description;
  final Timestamp startDate;
  final Timestamp endDate;
  final String projectId;
  final List<String> tasks;
  final List<String> members;
  final String createdBy;

  /// Constructor para crear una instancia de [SprintFirestore].
  ///
  /// [id] es el identificador único del sprint.
  /// [name] es el nombre del sprint.
  /// [description] es la descripción del sprint.
  /// [startDate] es la fecha de inicio del sprint.
  /// [endDate] es la fecha de finalización del sprint.
  /// [projectId] es el identificador del proyecto al que pertenece el sprint.
  /// [tasks] es una lista de identificadores de tareas asociadas al sprint.
  /// [members] es una lista de identificadores de los miembros del sprint.
  /// [createdBy] es el identificador del usuario que creó el sprint.
  SprintFirestore({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectId,
    required this.tasks,
    required this.members,
    required this.createdBy,
  });

  /// Crea una instancia de [SprintFirestore] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos del sprint.
  factory SprintFirestore.fromMap(Map<String, dynamic> map) {
    return SprintFirestore(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? Timestamp.now(),
      endDate: map['endDate'] ?? Timestamp.now(),
      projectId: map['projectId'] ?? '',
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((task) => task.toString())
              .toList() ??
          [],
      members: (map['members'] as List<dynamic>?)
              ?.map((member) => member.toString())
              .toList() ??
          [],
      createdBy: map['createdBy'] ?? '',
    );
  }

  /// Convierte una instancia de [SprintFirestore] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'projectId': projectId,
      'tasks': tasks,
      'members': members,
      'createdBy': createdBy,
    };
  }

  /// Crea una instancia vacía de [SprintFirestore].
  factory SprintFirestore.empty() {
    return SprintFirestore(
      id: '',
      name: '',
      description: '',
      startDate: Timestamp.fromDate(DateTime.now()),
      endDate: Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      projectId: '',
      tasks: [],
      members: [],
      createdBy: '',
    );
  }

  /// Crea una instancia de [SprintFirestore] solo con el identificador.
  ///
  /// [id] es el identificador único del sprint.
  factory SprintFirestore.onlyId(String id) {
    return SprintFirestore(
      id: id,
      name: '',
      description: '',
      startDate: Timestamp.fromDate(DateTime.now()),
      endDate: Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      projectId: '',
      tasks: [],
      members: [],
      createdBy: '',
    );
  }

  @override
  String toString() {
    return 'SprintFirestore: $id, Name: $name, Description: $description, Start Date: $startDate, End Date: $endDate, Project ID: $projectId, Tasks: $tasks, Members: $members';
  }
}
