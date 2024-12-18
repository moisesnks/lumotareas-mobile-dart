//Servicio de datos del proyecto.
library;

import 'package:lumotareas/models/firestore/sprint.dart';
import 'package:lumotareas/models/firestore/tareas.dart';
import 'package:lumotareas/models/firestore/proyecto.dart';
import 'package:lumotareas/models/proyecto/proyecto.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/sprint/sprint.dart';
import 'package:lumotareas/services/database_service.dart';
import 'package:logger/logger.dart';

/// Servicio de datos del proyecto.
class ProjectDataService {
  final Logger _logger = Logger();
  final DatabaseService _databaseService = DatabaseService();

  /// Elimina un sprint de un proyecto.
  ///
  /// [proyecto] es el proyecto del cual se va a eliminar el sprint.
  /// [sprint] es el sprint que se va a eliminar.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> removeSprint(
      ProyectoFirestore proyecto, SprintFirestore sprint) async {
    try {
      String sprintId = sprint.id;
      ProyectoFirestore withoutSprint = ProyectoFirestore(
        createdBy: proyecto.createdBy,
        id: proyecto.id,
        nombre: proyecto.nombre,
        orgName: proyecto.orgName,
        sprints: proyecto.sprints..remove(sprintId),
        descripcion: proyecto.descripcion,
        asignados: proyecto.asignados,
      );

      // Borrar el sprint
      Response response = await _databaseService.deleteDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints',
        sprintId,
      );
      if (!response.success) {
        _logger.w('Error al eliminar sprint: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }

      // Actualizar el proyecto
      Response finalResponse = await updateProyecto(withoutSprint);
      if (finalResponse.success) {
        _logger
            .i('Proyecto actualizado correctamente después de eliminar sprint');
        return Response(
          success: true,
          data: finalResponse.data,
          message: 'Sprint eliminado correctamente',
        );
      } else {
        _logger.w(
            'Error al actualizar proyecto después de eliminar sprint: ${finalResponse.message}');
        return Response(
          success: false,
          message: finalResponse.message,
        );
      }
    } catch (e) {
      _logger.e('Error al eliminar sprint: $e');
      return Response(
        success: false,
        message: 'Error al eliminar sprint',
      );
    }
  }

  /// Agrega un sprint a un proyecto.
  ///
  /// [proyecto] es el proyecto al cual se va a agregar el sprint.
  /// [sprint] es el sprint que se va a agregar.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> addSprint(
      ProyectoFirestore proyecto, SprintFirestore sprint) async {
    try {
      Response response = await _databaseService.addDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints',
        documentId: sprint.id,
        data: sprint.toMap(),
      );
      if (response.success) {
        _logger.i('Sprint agregado correctamente');
        // Obtener el proyecto actualizado
        Response<Proyecto> proyectoResponse = await getData(proyecto);
        if (proyectoResponse.success) {
          // Actualizar el proyectoFirestore
          ProyectoFirestore proyectoFirestore = ProyectoFirestore(
            createdBy: proyecto.createdBy,
            id: proyecto.id,
            nombre: proyecto.nombre,
            orgName: proyecto.orgName,
            sprints: proyecto.sprints..add(sprint.id),
            descripcion: proyecto.descripcion,
            asignados: proyecto.asignados,
          );

          Response finalResponse = await updateProyecto(proyectoFirestore);
          if (finalResponse.success) {
            _logger.i(
                'Proyecto actualizado correctamente después de agregar sprint');
            return Response(
              success: true,
              data: finalResponse.data,
              message: 'Sprint agregado correctamente',
            );
          } else {
            _logger.w(
                'Error al actualizar proyecto después de agregar sprint: ${finalResponse.message}');
            return Response(
              success: false,
              message: finalResponse.message,
            );
          }
        } else {
          _logger.w(
              'Error al obtener proyecto después de agregar sprint: ${proyectoResponse.message}');
          return Response(
            success: false,
            message: proyectoResponse.message,
          );
        }
      } else {
        _logger.w('Error al agregar sprint: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al agregar sprint: $e');
      return Response(
        success: false,
        message: 'Error al agregar sprint',
      );
    }
  }

  /// Actualiza un proyecto.
  ///
  /// [proyecto] es el proyecto que se va a actualizar.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> updateProyecto(ProyectoFirestore proyecto) async {
    try {
      Response response = await _databaseService.updateDocument(
        'organizaciones/${proyecto.orgName}/proyectos',
        proyecto.id,
        proyecto.toMap(),
      );
      if (response.success) {
        _logger.i('Proyecto actualizado correctamente');
        // Obtener el proyecto actualizado
        Response<Proyecto> proyectoResponse = await getData(proyecto);
        if (proyectoResponse.success) {
          _logger.i('Proyecto obtenido correctamente después de actualizar');
          return Response(
            success: true,
            data: proyectoResponse.data,
            message: 'Proyecto actualizado correctamente',
          );
        } else {
          _logger.w(
              'Error al obtener proyecto después de actualizar: ${proyectoResponse.message}');
          return Response(
            success: false,
            message: proyectoResponse.message,
          );
        }
      } else {
        _logger.w('Error al actualizar proyecto: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al actualizar proyecto: $e');
      return Response(
        success: false,
        message: 'Error al actualizar proyecto',
      );
    }
  }

  /// Elimina una tarea de un sprint dentro de un proyecto.
  ///
  /// [proyecto] es el proyecto que contiene la tarea.
  /// [sprint] es el sprint que contiene la tarea.
  /// [tarea] es la tarea que se va a eliminar.
  /// [userId] es el ID del usuario que está eliminando la tarea.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> removeTarea(ProyectoFirestore proyecto,
      SprintFirestore sprint, TareaFirestore tarea, String userId) async {
    try {
      // Eliminar la tarea
      Response response = await _databaseService.deleteDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints/${sprint.id}/tareas',
        tarea.id,
      );
      if (!response.success) {
        _logger.w('Error al eliminar tarea: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }

      // Crear un SprintFirestore con la tarea eliminada
      SprintFirestore sprintFirestore = SprintFirestore(
        createdBy: userId,
        id: sprint.id,
        name: sprint.name,
        description: sprint.description,
        tasks: sprint.tasks..remove(tarea.id),
        projectId: sprint.projectId,
        startDate: sprint.startDate,
        endDate: sprint.endDate,
        members: sprint.members,
      );

      // Actualizar el sprint en el proyecto
      Response sprintResponse = await _databaseService.updateDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints',
        sprint.id,
        sprintFirestore.toMap(),
      );

      if (sprintResponse.success) {
        _logger.i('Sprint actualizado correctamente después de eliminar tarea');

        // Obtener el proyecto actualizado
        Response<Proyecto> proyectoResponse = await getData(proyecto);
        if (proyectoResponse.success) {
          _logger
              .i('Proyecto obtenido correctamente después de eliminar tarea');
          return Response(
            success: true,
            data: proyectoResponse.data,
            message: 'Tarea eliminada correctamente',
          );
        } else {
          _logger.w(
              'Error al obtener proyecto después de eliminar tarea: ${proyectoResponse.message}');
          return Response(
            success: false,
            message: proyectoResponse.message,
          );
        }
      } else {
        _logger.w('Error al actualizar sprint: ${sprintResponse.message}');
        return Response(
          success: false,
          message: sprintResponse.message,
        );
      }
    } catch (e) {
      _logger.e('Error al eliminar tarea: $e');
      return Response(
        success: false,
        message: 'Error al eliminar tarea',
      );
    }
  }

  /// Agrega una tarea a un sprint dentro de un proyecto.
  ///
  /// [proyecto] es el proyecto que contiene la tarea.
  /// [sprint] es el sprint al cual se va a agregar la tarea.
  /// [tarea] es la tarea que se va a agregar.
  /// [userId] es el ID del usuario que está agregando la tarea.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> addTarea(ProyectoFirestore proyecto,
      SprintFirestore sprint, TareaFirestore tarea, String userId) async {
    try {
      Response response = await _databaseService.addDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints/${tarea.sprintId}/tareas',
        documentId: tarea.id,
        data: tarea.toMap(),
      );
      if (response.success) {
        _logger.i('Tarea agregada correctamente');
        // Crear un SprintFirestore con la tarea agregada
        SprintFirestore sprintFirestore = SprintFirestore(
          createdBy: userId,
          id: sprint.id,
          name: sprint.name,
          description: sprint.description,
          tasks: sprint.tasks..add(tarea.id),
          projectId: sprint.projectId,
          startDate: sprint.startDate,
          endDate: sprint.endDate,
          members: sprint.members,
        );

        // Actualizar el sprint en el proyecto
        Response sprintResponse = await _databaseService.updateDocument(
          'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints',
          sprint.id,
          sprintFirestore.toMap(),
        );

        if (sprintResponse.success) {
          _logger
              .i('Sprint actualizado correctamente después de agregar tarea');

          // Obtener el proyecto actualizado
          Response<Proyecto> proyectoResponse = await getData(proyecto);
          if (proyectoResponse.success) {
            _logger
                .i('Proyecto obtenido correctamente después de agregar tarea');
            return Response(
              success: true,
              data: proyectoResponse.data,
              message: 'Tarea agregada correctamente',
            );
          } else {
            _logger.w(
                'Error al obtener proyecto después de agregar tarea: ${proyectoResponse.message}');
            return Response(
              success: false,
              message: proyectoResponse.message,
            );
          }
        } else {
          _logger.w('Error al actualizar sprint: ${sprintResponse.message}');
          return Response(
            success: false,
            message: sprintResponse.message,
          );
        }
      } else {
        _logger.w('Error al agregar tarea: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al agregar tarea: $e');
      return Response(
        success: false,
        message: 'Error al agregar tarea',
      );
    }
  }

  /// Actualiza una tarea.
  ///
  /// [proyecto] es el proyecto que contiene la tarea.
  /// [tarea] es la tarea que se va a actualizar.
  /// Devuelve una [Response] indicando el éxito o fracaso de la operación.
  Future<Response<Proyecto>> updateTarea(
      ProyectoFirestore proyecto, TareaFirestore tarea) async {
    try {
      Response response = await _databaseService.updateDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints/${tarea.sprintId}/tareas',
        tarea.id,
        tarea.toMap(),
      );
      if (response.success) {
        _logger.i('Tarea actualizada correctamente');

        // Obtener el proyecto actualizado
        Response<Proyecto> proyectoResponse = await getData(proyecto);
        if (proyectoResponse.success) {
          _logger
              .i('Proyecto obtenido correctamente después de actualizar tarea');
          return Response(
            success: true,
            data: proyectoResponse.data,
            message: 'Tarea actualizada correctamente',
          );
        } else {
          _logger.w(
              'Error al obtener proyecto después de actualizar tarea: ${proyectoResponse.message}');
          return Response(
            success: false,
            message: proyectoResponse.message,
          );
        }
      } else {
        _logger.w('Error al actualizar tarea: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al actualizar tarea: $e');
      return Response(
        success: false,
        message: 'Error al actualizar tarea',
      );
    }
  }

  /// Obtiene una tarea específica.
  ///
  /// [proyecto] es el proyecto que contiene la tarea.
  /// [sprint] es el sprint que contiene la tarea.
  /// [tareaId] es el ID de la tarea que se va a obtener.
  /// Devuelve una [Response] con la tarea obtenida o un mensaje de error.
  Future<Response<TareaFirestore>> getTarea(ProyectoFirestore proyecto,
      SprintFirestore sprint, String tareaId) async {
    try {
      Response response = await _databaseService.getDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints/${sprint.id}/tareas',
        tareaId,
      );
      if (response.success) {
        _logger.i('Tarea obtenida correctamente');
        return Response(
          success: true,
          data: TareaFirestore.fromMap(tareaId, response.data),
          message: response.message,
        );
      } else {
        _logger.w('Error al obtener tarea: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al obtener tarea: $e');
      return Response(
        success: false,
        message: 'Error al obtener tarea',
      );
    }
  }

  /// Obtiene un sprint específico.
  ///
  /// [proyecto] es el proyecto que contiene el sprint.
  /// [sprintId] es el ID del sprint que se va a obtener.
  /// Devuelve una [Response] con el sprint obtenido o un mensaje de error.
  Future<Response<Sprint>> getSprint(
      ProyectoFirestore proyecto, String sprintId) async {
    try {
      Response response = await _databaseService.getDocument(
        'organizaciones/${proyecto.orgName}/proyectos/${proyecto.id}/sprints',
        sprintId,
      );
      if (!response.success) {
        _logger.w('Error al obtener sprint: ${response.message}');
        return Response(
          success: false,
          message: response.message,
        );
      }
      SprintFirestore sprintFirestore = SprintFirestore.fromMap(response.data);
      List<String> tasks = sprintFirestore.tasks;
      List<TareaFirestore> tareas = [];
      for (String tareaId in tasks) {
        Response<TareaFirestore> tareaResponse =
            await getTarea(proyecto, sprintFirestore, tareaId);
        if (tareaResponse.success) {
          tareas.add(tareaResponse.data!);
        }
      }
      Sprint sprint = Sprint(
        sprintFirestore: sprintFirestore,
        tareas: tareas,
      );
      _logger.i('Sprint obtenido correctamente');
      return Response(
        success: true,
        data: sprint,
        message: response.message,
      );
    } catch (e) {
      _logger.e('Error al obtener sprint: $e');
      return Response(
        success: false,
        message: 'Error al obtener sprint',
      );
    }
  }

  /// Obtiene un proyecto específico.
  ///
  /// [proyecto] es el proyecto que se va a obtener.
  /// Devuelve una [Response] con el proyecto obtenido o un mensaje de error.
  Future<Response<Proyecto>> getData(ProyectoFirestore proyecto) async {
    _logger.i('Obteniendo proyecto');
    try {
      List<String> sprints = proyecto.sprints;
      List<Sprint> sprintsData = [];
      for (String sprintId in sprints) {
        Response<Sprint> sprintResponse = await getSprint(proyecto, sprintId);
        if (sprintResponse.success) {
          sprintsData.add(sprintResponse.data!);
        }
      }
      Proyecto finalProyecto = Proyecto(
        proyecto: proyecto,
        sprints: sprintsData,
      );
      _logger.i('Proyecto obtenido correctamente $finalProyecto');
      return Response(
        success: true,
        data: finalProyecto,
        message: 'Proyecto obtenido correctamente',
      );
    } catch (e) {
      _logger.e('Error al obtener proyecto: $e');
      return Response(
        success: false,
        message: 'Error al obtener proyecto',
      );
    }
  }
}
