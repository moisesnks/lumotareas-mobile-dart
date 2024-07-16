import 'package:cloud_firestore/cloud_firestore.dart';

class Subtarea {
  final String id;
  final String name;
  final String description;
  bool done;
  String completedBy;

  Subtarea({
    required this.id,
    required this.name,
    required this.description,
    required this.done,
    this.completedBy = '',
  });

  factory Subtarea.fromMap(Map<String, dynamic> map) {
    return Subtarea(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      done: map['done'] ?? false,
      completedBy: map['completedBy'] ?? '',
    );
  }

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

class Logs {
  final String uid;
  final String message;
  final Timestamp timestamp;

  Logs({
    required this.uid,
    required this.message,
    required this.timestamp,
  });

  factory Logs.fromMap(Map<String, dynamic> map) {
    return Logs(
      uid: map['uid'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'message': message,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'Log: UID: $uid, Mensaje: $message, Fecha: $timestamp';
  }
}

class SmallUser {
  final String uid;
  final String nombre;
  final String photoUrl;

  SmallUser({
    required this.uid,
    required this.nombre,
    required this.photoUrl,
  });

  factory SmallUser.fromMap(Map<String, dynamic> map) {
    return SmallUser(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'Usuario: UID: $uid, Nombre: $nombre, Foto: $photoUrl';
  }
}

class Comentarios {
  final String message;
  final SmallUser user;
  final Timestamp fecha;

  Comentarios({
    required this.message,
    required this.user,
    required this.fecha,
  });

  factory Comentarios.fromMap(Map<String, dynamic> map) {
    return Comentarios(
      message: map['message'] ?? '',
      user: SmallUser.fromMap(map['user'] ?? {}),
      fecha: map['fecha'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'user': user.toMap(),
      'fecha': fecha,
    };
  }

  @override
  String toString() {
    return 'Comentario: Mensaje: $message, Usuario: $user , Fecha: $fecha';
  }
}

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

  factory TareaFirestore.fromMap(String id, Map<String, dynamic> map) {
    return TareaFirestore(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
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

  int get totalSubtareas => subtareas.length;
  int get subtareasCompletadas => subtareas.where((s) => s.done).length;
  int get subtareasPendientes => totalSubtareas - subtareasCompletadas;
  double get progress =>
      (totalSubtareas == 0) ? 0 : (subtareasCompletadas / totalSubtareas);

  @override
  String toString() {
    return 'Tarea: $id, Nombre: $name, Descripción: $description, Fecha de Inicio: $startDate, Fecha de Fin: $endDate, Asignados: $asignados Subtareas: $subtareas, Comentarios: $comentarios, Logs: $logs, Privada: $private, Sprint: $sprintId Proyecto: $projectId';
  }
}
