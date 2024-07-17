/// @nodoc
library;
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/utils/time.dart';

import '../firestore/sprint.dart';

class Sprint {
  final SprintFirestore sprintFirestore;
  final List<TareaFirestore> tareas;

  Sprint({
    required this.sprintFirestore,
    required this.tareas,
  });

  factory Sprint.fromMap(Map<String, dynamic> map) {
    return Sprint(
      sprintFirestore: SprintFirestore.fromMap(map['sprint']),
      tareas: (map['tareas'] as List<dynamic>?)
              ?.map((tarea) => TareaFirestore.fromMap(tarea['id'], tarea))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sprint': sprintFirestore.toMap(),
      'tareas': tareas.map((tarea) => tarea.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Sprint: ${sprintFirestore.id}, Name: ${sprintFirestore.name}, Description: ${sprintFirestore.description}, Start Date: ${sprintFirestore.startDate}, End Date: ${sprintFirestore.endDate}, Project ID: ${sprintFirestore.projectId}, Tasks: ${sprintFirestore.tasks}, Members: ${sprintFirestore.members}';
  }

  factory Sprint.empty() {
    return Sprint(
      sprintFirestore: SprintFirestore.empty(),
      tareas: [],
    );
  }

  String get status {
    if (DateTime.now().isAfter(sprintFirestore.endDate.toDate())) {
      return 'Completado';
    } else if (DateTime.now().isBefore(sprintFirestore.startDate.toDate())) {
      return 'Pendiente';
    } else {
      return 'En progreso';
    }
  }

  String get startDate => Utils.formatTimestamp(sprintFirestore.startDate);
  String get endDate => Utils.formatTimestamp(sprintFirestore.endDate);

  double get progress {
    int total = 0;
    int completadas = 0;
    for (var tarea in tareas) {
      total += tarea.subtareas.length;
      completadas += tarea.subtareas.where((subtarea) => subtarea.done).length;
    }
    return total == 0 ? 0 : completadas / total;
  }

  String get quedanDias {
    final days =
        sprintFirestore.endDate.toDate().difference(DateTime.now()).inDays;
    return 'Queda${days == 1 ? '' : 'n'} $days día${days == 1 ? '' : 's'}';
  }

  String get totalTareas => tareas.length.toString();
  String get totalSubtareas {
    int total = 0;
    for (var tarea in tareas) {
      total += tarea.subtareas.length;
    }
    return total.toString();
  }

  String get tareasCompletadas {
    int total = 0;
    for (var tarea in tareas) {
      if (tarea.subtareas.every((subtarea) => subtarea.done)) {
        total++;
      }
    }
    return total.toString();
  }

  String get tareasEnProgreso {
    int total = 0;
    for (var tarea in tareas) {
      if (tarea.subtareas.every((subtarea) => subtarea.done)) {
        continue;
      }
      if (DateTime.now().isBefore(tarea.endDate.toDate())) {
        total++;
      }
    }
    return total.toString();
  }

  String get totalSubtareasCompletadas {
    int total = 0;
    for (var tarea in tareas) {
      for (var subtarea in tarea.subtareas) {
        if (subtarea.done) {
          total++;
        }
      }
    }
    return total.toString();
  }
}
