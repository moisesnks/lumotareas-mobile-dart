import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/solicitud.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/services/firestore_service.dart';
import 'package:lumotareas/models/project.dart';
import 'package:logger/logger.dart';

class OrganizationService {
  final FirestoreService _firestoreService = FirestoreService();
  final Logger _logger = Logger();
  Future<Map<String, dynamic>> likeOrganization(
      String orgName, String uid, bool addLike) async {
    try {
      final result =
          await _firestoreService.getDocument('organizaciones', orgName);

      if (result['found']) {
        Organization organization = Organization.fromMap(result['data']);
        if (addLike && !organization.likes.contains(uid)) {
          // Agregar el like si no existe
          organization.likes.add(uid);
        } else if (!addLike && organization.likes.contains(uid)) {
          // Quitar el like si existe
          organization.likes.remove(uid);
        } else {
          // No hacer cambios si ya existe o se intenta quitar sin existir
          return {
            'success': false,
            'message': addLike
                ? 'Ya has dado like a esta organización'
                : 'No has dado like previamente a esta organización',
          };
        }

        await _firestoreService.updateDocument(
            'organizaciones', orgName, organization.toMap());
        return {
          'success': true,
          'message': addLike
              ? 'Like añadido correctamente'
              : 'Like quitado correctamente',
        };
      } else {
        return {
          'success': false,
          'message': 'La organización no existe',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al dar/quitar like a la organización: $e',
      };
    }
  }

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

      // Ajustar projectId para que sea null si está vacío
      String? projectId = project.id.isNotEmpty ? project.id : null;

      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/proyectos', projectId, data);

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
    SolicitudOrg solicitudOrg = SolicitudOrg(
      id: '',
      estado: 'pendiente',
      fecha: DateTime.now().toString(),
      solicitud: solicitud,
      uid: uid,
    );

    try {
      final result = await _firestoreService.addDocument(
          'organizaciones/$orgName/solicitudes', null, solicitudOrg.toMap());

      if (result['success']) {
        // Actualizar la solicitud con el id del documento
        await _firestoreService.updateDocument(
            'organizaciones/$orgName/solicitudes', result['documentId'], {
          'id': result['documentId'],
        });

        return {
          'success': true,
          'message': 'Solicitud registrada con éxito',
          'documentId': result['documentId'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al enviar la solicitud',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al enviar la solicitud: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getSolicitud(
      String orgName, String solicitudId) async {
    try {
      final result = await _firestoreService.getDocument(
          'organizaciones/$orgName/solicitudes', solicitudId);

      if (result['found']) {
        var doc = result['data'];
        Map<String, dynamic> solicitud = {
          'respuesta': doc['respuesta'],
          'estado': doc['estado'],
          'fecha': doc['fecha'],
          'uid': doc['uid'],
          'solicitudId': solicitudId,
        };
        return {
          'success': true,
          'solicitud': solicitud,
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
        'message': 'Error al obtener la solicitud: $e',
      };
    }
  }

  Future<List<SolicitudOrg>> getSolicitudes(
      String orgName, Usuario user) async {
    if (!user.isOwnerOfOrganization(orgName)) {
      return [];
    }
    try {
      _logger.i(
          'Intentado obtener las solicitudes de la organización, orgName: $orgName, user: $user');
      final result = await _firestoreService
          .getCollection('organizaciones/$orgName/solicitudes');

      if (result['found']) {
        List<SolicitudOrg> solicitudes = result['data']
            .map<SolicitudOrg>((doc) => SolicitudOrg.fromMap(doc['id'], doc))
            .toList();
        _logger.i('Solicitudes de la organización cargadas $solicitudes');
        return solicitudes;
      } else {
        _logger.e('No se encontraron solicitudes de la organización');
        return [];
      }
    } catch (e) {
      _logger.e('Error al obtener las solicitudes de la organización: $e');
      return [];
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
