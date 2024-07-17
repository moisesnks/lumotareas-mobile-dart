/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/sprint.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/proyecto/proyecto.dart';
import 'package:lumotareas/lib/models/response.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/services/project_data_service.dart';

class ProjectDataProvider extends ChangeNotifier {
  final ProjectDataService _projectDataService = ProjectDataService();
  Proyecto? _proyecto;

  Proyecto? get proyecto => _proyecto;

  Future<void> loadProyecto(ProyectoFirestore proyectoFirestore) async {
    Response<Proyecto> response =
        await _projectDataService.getData(proyectoFirestore);
    if (response.success) {
      _proyecto = response.data;
      notifyListeners();
    } else {
      // Handle error if needed
    }
  }

  Future<void> updateTarea(TareaFirestore tarea) async {
    if (_proyecto == null) {
      return;
    } else {
      Response<Proyecto> response =
          await _projectDataService.updateTarea(_proyecto!.proyecto, tarea);
      if (response.success) {
        _proyecto = response.data;
        notifyListeners();
      } else {
        // Handle error if needed
      }
    }
  }

  Future<void> addTarea(
      SprintFirestore sprint, TareaFirestore tarea, Usuario currentUser) async {
    if (_proyecto == null) {
      return;
    } else {
      Response<Proyecto> response = await _projectDataService.addTarea(
          _proyecto!.proyecto, sprint, tarea, currentUser.uid);
      if (response.success) {
        _proyecto = response.data;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTarea(
      BuildContext context, TareaFirestore tarea, Usuario currentUser) async {
    if (_proyecto == null) {
      return;
    } else {
      final String sprintId = tarea.sprintId;
      SprintFirestore? sprint;
      for (var s in _proyecto!.sprints) {
        if (s.sprintFirestore.id == sprintId) {
          sprint = s.sprintFirestore;
          break;
        }
      }
      if (sprint == null) {
        return;
      }
      Navigator.pushNamed(context, '/loading', arguments: 'Eliminando tarea');
      Response<Proyecto> response = await _projectDataService.removeTarea(
          _proyecto!.proyecto, sprint, tarea, currentUser.uid);
      if (response.success) {
        _proyecto = response.data;
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        notifyListeners();
      }
    }
  }

  Future<void> deleteSprint(
      BuildContext context, SprintFirestore sprint) async {
    if (_proyecto == null) {
      return;
    } else {
      Navigator.pushNamed(context, '/loading', arguments: 'Eliminando sprint');
      Response<Proyecto> response =
          await _projectDataService.removeSprint(_proyecto!.proyecto, sprint);
      if (response.success) {
        _proyecto = response.data;
        if (context.mounted) {
          Navigator.pop(context);
        }
        notifyListeners();
      }
      if (context.mounted) {
        Navigator.pop(context); // Close loading screen
        Navigator.pop(context); // Close confirm delete sprint screen
      }
    }
  }

  Future<void> addSprint(BuildContext context, SprintFirestore sprint) async {
    if (_proyecto == null) {
      return;
    } else {
      Navigator.pushNamed(context, '/loading', arguments: 'Creando sprint...');
      Response<Proyecto> response =
          await _projectDataService.addSprint(_proyecto!.proyecto, sprint);
      if (response.success) {
        _proyecto = response.data;
        notifyListeners();
      } else {
        if (context.mounted) {
          Navigator.pop(context); // Close loading screen
          Navigator.pop(context); // Close create sprint screen
        }
      }
    }
  }
}
