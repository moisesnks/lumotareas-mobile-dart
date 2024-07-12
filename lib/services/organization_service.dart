import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/services/firestore_service.dart';
import 'package:lumotareas/models/project.dart';

class OrganizationService {
  final FirestoreService _firestoreService = FirestoreService();

  // Crear una tarea dentro de un sprint
  //TODO: Cambiar el parametro de task por un modelo de tarea
  Future<Map<String, dynamic>> createTask(String orgName, String projectId,
      String sprintId, Map<String, dynamic> task) async {
    try {
      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/proyectos/$projectId/sprints/$sprintId/tareas',
          null,
          task);

      if (result['success']) {
        return {
          'success': true,
          'message': 'Tarea creada correctamente',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear la tarea',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear la tarea: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getOrganizationsByPrefix(String prefix) async {
    try {
      final result = await _firestoreService.getDocumentsByPrefix(
          'organizaciones', prefix);

      if (result['found']) {
        List<Organization> organizations = [];
        for (var doc in result['data']) {
          organizations.add(Organization.fromMap(doc));
        }
        return {
          'success': true,
          'organizations': organizations,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener las organizaciones: $e',
      };
    }
  }

  // Crear un sprint dentro de un proyecto
  Future<Map<String, dynamic>> createSprint(
      String orgName, String projectId, Map<String, dynamic> sprint) async {
    try {
      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/proyectos/$projectId/sprints', null, sprint);

      if (result['success']) {
        return {
          'success': true,
          'message': 'Sprint creado correctamente',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear el sprint',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear el sprint: $e',
      };
    }
  }

  // Crear un proyecto dentro de la organización
  Future<Map<String, dynamic>> createProject(
      String orgName, Project project) async {
    try {
      // Convertir el objeto Project a un mapa para almacenarlo
      Map<String, dynamic> data = project.toMap();

      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/proyectos', project.id, data);

      if (result['success']) {
        return {
          'success': true,
          'message': 'Proyecto creado correctamente',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear el proyecto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear el proyecto: $e',
      };
    }
  }
  //metodo para obtener la lista de proyectos de una organizacion

  Future<Map<String, dynamic>> getProjects(String orgName) async {
    try {
      final result = await _firestoreService
          .getCollection('organizaciones/$orgName/proyectos');

      if (result['found']) {
        List<Project> projects = [];
        for (var doc in result['data']) {
          projects.add(Project.fromMap(doc));
        }
        return {
          'success': true,
          'projects': projects,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener los proyectos: $e',
      };
    }
  }

//metodo para obtener la lista de las organizaciones mas polulares

  Future<Map<String, dynamic>> getPopularOrganizations() async {
    try {
      var result = await _firestoreService.getCollection(
        'organizaciones',
        limit: 10,
        orderByField: 'likes',
        descending: true,
      );

      if (result['found']) {
        List<Organization> organizations =
            result['data'].map<Organization>((doc) {
          return Organization.fromMap(doc);
        }).toList();

        return {
          'success': true,
          'organizations': organizations,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener las organizaciones: $e',
      };
    }
  }

  Future<Map<String, dynamic>> registerSolicitud(
      String orgName, Map<String, dynamic> solicitud, String uid) async {
    // Crear un mapa con los datos de la solicitud
    Map<String, dynamic> data = {
      'solicitud': solicitud,
      'uid': uid,
      'estado': 'pendiente',
      'fecha': DateTime.now().toString(),
    };
    try {
      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/solicitudes',
          null, // Firestore generará un ID único
          data);

      if (result['success']) {
        return {
          'success': true,
          'message': 'Solicitud registrada correctamente',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al registrar la solicitud',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar la solicitud: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getOrganization(String orgName) async {
    try {
      final result =
          await _firestoreService.getDocument('organizaciones', orgName);

      if (result['found']) {
        // Convertir los datos en un objeto Organization
        Organization organization = Organization.fromMap(result['data']);
        return {
          'success': true,
          'organization': organization,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al obtener la organización: $e',
      };
    }
  }

  Future<Map<String, dynamic>> createOrganization(
      Organization organization) async {
    try {
      // Convertir el objeto Organization a un mapa para almacenarlo
      Map<String, dynamic> data = organization.toMap();

      final result = await _firestoreService.addDocument(
          'organizaciones', organization.nombre, data);

      if (result['success']) {
        // Crear la colección 'solicitudes' dentro de la organización
        await _firestoreService.addDocument(
            'organizaciones/${organization.nombre}/solicitudes',
            'initial',
            {'message': 'Initial solicitud document'});

        // Crear la colección 'tareas' dentro de la organización
        await _firestoreService.addDocument(
            'organizaciones/${organization.nombre}/proyectos',
            'initial',
            {'message': 'Initial proyectos document'});

        return {
          'success': true,
          'message':
              'Organización creada correctamente con la colección solicitudes y proyectos',
          'ref': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al crear la organización',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al crear la organización: $e',
      };
    }
  }
}
