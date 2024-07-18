import 'package:intl/intl.dart';
import 'package:lumotareas/models/firestore/proyecto.dart';
import 'package:lumotareas/models/firestore/solicitud.dart';
import 'package:lumotareas/models/response.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/database_service.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/firestore/organizacion.dart';

class OrganizationDataService {
  final Logger _logger = Logger();
  final DatabaseService _databaseService = DatabaseService();

  Future<Usuario> getOwner(String owner) async {
    try {
      Response response = await _databaseService.getDocument('users', owner);
      if (response.success) {
        return Usuario.fromMap(owner, response.data);
      } else {
        return Usuario.empty();
      }
    } catch (e) {
      _logger.e('Error al obtener dueño de la organización: $e');
      return Usuario.empty();
    }
  }

  Future<Response<List<Organizacion>>> getPopulars() async {
    try {
      Response response = await _databaseService.getCollection('organizaciones',
          limit: 10, orderByField: 'likes', descending: true);

      if (response.success) {
        final List<Organizacion> organizaciones = [];
        for (Map<String, dynamic> org in response.data) {
          OrganizacionFirestore orgFirestore =
              OrganizacionFirestore.fromMap(org);
          final List<Usuario> miembros =
              await getMembers(orgFirestore.miembros);
          final List<Solicitud> solicitudes = await getRequests(orgFirestore);
          final List<ProyectoFirestore> proyectos =
              await getProjects(orgFirestore.nombre);
          final Usuario owner = await getOwner(orgFirestore.owner['uid'] ?? '');
          Organizacion organizacion = Organizacion(
            nombre: orgFirestore.nombre,
            descripcion: orgFirestore.descripcion,
            proyectos: proyectos,
            solicitudes: solicitudes,
            formulario: orgFirestore.formulario,
            likes: orgFirestore.likes,
            miembros: miembros,
            owner: owner,
            vacantes: orgFirestore.vacantes,
            imageUrl: orgFirestore.imageUrl,
          );
          organizaciones.add(organizacion);
        }
        return Response(
          success: true,
          data: organizaciones,
          message: 'Organizaciones destacadas obtenidas correctamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al obtener organizaciones destacadas',
        );
      }
    } catch (e) {
      _logger.e('Error al obtener organizaciones destacadas: $e');
      return Response(
        success: false,
        message: 'Error al obtener organizaciones destacadas',
      );
    }
  }

  Future<List<Usuario>> getMembers(List<String> members) async {
    try {
      final List<Usuario> miembros = [];
      for (String member in members) {
        Response response = await _databaseService.getDocument('users', member);
        if (response.success) {
          miembros.add(Usuario.fromMap(member, response.data));
        } else {
          _logger.e(
              'Error al obtener miembro de la organización: ${response.message}');
        }
      }
      return miembros;
    } catch (e) {
      _logger.e('Error al obtener miembros de la organización: $e');
      return [];
    }
  }

  Future<Response<String>> addRequest(String orgName,
      Map<String, dynamic> solicitud, Usuario currentUser) async {
    try {
      // Buscar si ya existe una solicitud
      Response response = await _databaseService.getDocument(
          'organizaciones/$orgName/solicitudes', currentUser.uid);
      if (response.success) {
        return Response(
          success: false,
          message: 'Ya has enviado una solicitud a esta organización',
        );
      }

      // Buscar en string uid en la List<String> miembros de la organización
      response = await _databaseService.getDocument('organizaciones', orgName);
      if (!response.success) {
        return Response(
          success: false,
          message: 'Organización no encontrada',
        );
      }
      OrganizacionFirestore organizacion =
          OrganizacionFirestore.fromMap(response.data);
      if (organizacion.miembros.contains(currentUser.uid)) {
        return Response(
          success: false,
          message: 'Ya eres miembro de esta organización',
        );
      }
      Solicitud solicitudObj = Solicitud(
        uid: currentUser.uid,
        id: '${DateFormat('dd_MMMM_yyyy_HH_mm', 'es_CL').format(DateTime.now())}_${currentUser.uid}',
        email: currentUser.email,
        estado: EstadoSolicitud.pendiente,
        fecha: DateTime.now().toIso8601String(),
        solicitud: solicitud,
      );

      response = await _databaseService.addDocument(
          'organizaciones/$orgName/solicitudes',
          documentId: solicitudObj.id,
          data: solicitudObj.toMap());
      if (response.success) {
        return Response(
          success: true,
          data: solicitudObj.id,
          message: 'Solicitud enviada correctamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al enviar solicitud',
        );
      }
    } catch (e) {
      _logger.e('Error al enviar solicitud: $e');
      return Response(
        success: false,
        message: 'Error al enviar solicitud',
      );
    }
  }

  Future<List<Solicitud>> getRequests(
      OrganizacionFirestore organizacion) async {
    try {
      final List<Solicitud> solicitudes = [];
      final orgName = organizacion.nombre;
      Response response = await _databaseService
          .getCollection('organizaciones/$orgName/solicitudes');
      if (response.success) {
        for (Map<String, dynamic> solicitud in response.data) {
          solicitudes.add(Solicitud.fromMap(solicitud['id'], solicitud));
        }
        return solicitudes;
      } else {
        return [];
      }
    } catch (e) {
      _logger.e('Error al obtener solicitudes de la organización: $e');
      return [];
    }
  }

  Future<Response<bool>> likeOrganization(
      Organizacion organizacion, Usuario currentUser) async {
    try {
      final List<String> likes = organizacion.likes;
      if (likes.contains(currentUser.uid)) {
        likes.remove(currentUser.uid);
      } else {
        likes.add(currentUser.uid);
      }
      OrganizacionFirestore orgFirestore = OrganizacionFirestore(
        nombre: organizacion.nombre,
        descripcion: organizacion.descripcion,
        proyectos:
            organizacion.proyectos.map((proyecto) => proyecto.id).toList(),
        likes: likes,
        miembros: organizacion.miembros.map((miembro) => miembro.uid).toList(),
        owner: {
          'uid': organizacion.owner.uid,
          'nombre': organizacion.owner.nombre,
        },
        vacantes: organizacion.vacantes,
        imageUrl: organizacion.imageUrl,
        formulario: organizacion.formulario,
      );
      Response response = await updateOrganization(orgFirestore);
      if (response.success) {
        return Response(
          success: true,
          data: likes.contains(currentUser.uid),
          message: 'Like actualizado correctamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al actualizar like',
        );
      }
    } catch (e) {
      _logger.e('Error al actualizar like de la organización: $e');
      return Response(
        success: false,
        message: 'Error al actualizar like',
      );
    }
  }

  Future<Response<Organizacion>> removeProyecto(
      Organizacion organizacion, String projectId) async {
    try {
      final orgName = organizacion.nombre;
      Response response = await _databaseService.deleteDocument(
          'organizaciones/$orgName/proyectos', projectId);
      if (response.success) {
        // Crear una organización de Firestore
        List<String> listProyectos = organizacion.proyectos
            .map((proyecto) => proyecto.id)
            .where((id) => id != projectId)
            .toList();
        OrganizacionFirestore orgFirestore = OrganizacionFirestore(
          nombre: organizacion.nombre,
          descripcion: organizacion.descripcion,
          proyectos: listProyectos,
          likes: organizacion.likes,
          miembros:
              organizacion.miembros.map((miembro) => miembro.uid).toList(),
          owner: {
            'uid': organizacion.owner.uid,
            'nombre': organizacion.owner.nombre,
          },
          vacantes: organizacion.vacantes,
          imageUrl: organizacion.imageUrl,
          formulario: organizacion.formulario,
        );

        // Actualizar la organización
        Response orgResponse = await updateOrganization(orgFirestore);
        if (orgResponse.success) {
          return Response(
            success: true,
            data: organizacion,
            message: 'Proyecto eliminado correctamente',
          );
        } else {
          return Response(
            success: false,
            message: 'Error al eliminar proyecto',
          );
        }
      } else {
        return Response(
          success: false,
          message: 'Error al eliminar proyecto',
        );
      }
    } catch (e) {
      _logger.e('Error al eliminar proyecto: $e');
      return Response(
        success: false,
        message: 'Error al eliminar proyecto',
      );
    }
  }

  Future<Response<Organizacion>> createProyecto(
      Organizacion organizacion, ProyectoFirestore proyecto) async {
    try {
      final orgName = organizacion.nombre;
      Response response = await _databaseService.addDocument(
          'organizaciones/$orgName/proyectos',
          documentId: proyecto.id,
          data: proyecto.toMap());
      if (response.success) {
        // Crear una organización de Firestore
        List<String> listProyectos =
            organizacion.proyectos.map((proyecto) => proyecto.id).toList();
        listProyectos.add(proyecto.id);
        OrganizacionFirestore orgFirestore = OrganizacionFirestore(
          nombre: organizacion.nombre,
          descripcion: organizacion.descripcion,
          proyectos: listProyectos,
          likes: organizacion.likes,
          miembros:
              organizacion.miembros.map((miembro) => miembro.uid).toList(),
          owner: {
            'uid': organizacion.owner.uid,
            'nombre': organizacion.owner.nombre,
          },
          vacantes: organizacion.vacantes,
          imageUrl: organizacion.imageUrl,
          formulario: organizacion.formulario,
        );

        // Actualizar la organización
        Response orgResponse = await updateOrganization(orgFirestore);
        if (orgResponse.success) {
          return Response(
            success: true,
            data: organizacion,
            message: 'Proyecto creado correctamente',
          );
        } else {
          return Response(
            success: false,
            message: 'Error al crear proyecto',
          );
        }
      } else {
        return Response(
          success: false,
          message: 'Error al crear proyecto',
        );
      }
    } catch (e) {
      _logger.e('Error al crear proyecto: $e');
      return Response(
        success: false,
        message: 'Error al crear proyecto',
      );
    }
  }

  Future<List<ProyectoFirestore>> getProjects(String orgName) async {
    try {
      final List<ProyectoFirestore> proyectos = [];
      Response response = await _databaseService
          .getCollection('organizaciones/$orgName/proyectos');
      if (response.success) {
        for (Map<String, dynamic> proyecto in response.data) {
          proyectos.add(ProyectoFirestore.fromMap(proyecto['id'], proyecto));
        }
        return proyectos;
      } else {
        return [];
      }
    } catch (e) {
      _logger.e('Error al obtener proyectos de la organización: $e');
      return [];
    }
  }

  Future<Response<Organizacion>> updateOrganization(
      OrganizacionFirestore organizacion) async {
    try {
      final orgName = organizacion.nombre;
      Response response = await _databaseService.updateDocument(
          'organizaciones', orgName, organizacion.toMap());
      if (response.success) {
        return Response(
          success: true,
          message: 'Organización actualizada correctamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al actualizar organización',
        );
      }
    } catch (e) {
      _logger.e('Error al actualizar organización: $e');
      return Response(
        success: false,
        message: 'Error al actualizar organización',
      );
    }
  }

  Future<Response<Organizacion>> getData(String orgId) async {
    try {
      Response response =
          await _databaseService.getDocument('organizaciones', orgId);
      if (response.success) {
        OrganizacionFirestore orgFirestore =
            OrganizacionFirestore.fromMap(response.data);
        final List<Usuario> miembros = await getMembers(orgFirestore.miembros);
        final List<Solicitud> solicitudes = await getRequests(orgFirestore);
        final List<ProyectoFirestore> proyectos =
            await getProjects(orgFirestore.nombre);
        final Usuario owner = await getOwner(orgFirestore.owner['uid'] ?? '');
        Organizacion org = Organizacion(
          nombre: orgFirestore.nombre,
          descripcion: orgFirestore.descripcion,
          proyectos: proyectos,
          solicitudes: solicitudes,
          formulario: orgFirestore.formulario,
          likes: orgFirestore.likes,
          miembros: miembros,
          owner: owner,
          vacantes: orgFirestore.vacantes,
          imageUrl: orgFirestore.imageUrl,
        );
        return Response(
          success: true,
          data: org,
          message: response.message,
        );
      } else {
        return Response(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      _logger.e('Error al obtener datos de la organización: $e');
      return Future.value(Response(
        success: false,
        message: 'Error al obtener datos de la organización',
      ));
    }
  }

  Future<Response<List<Organizacion>>> getOrganizationsByPrefix(
      String prefix) async {
    try {
      final Response response =
          await _databaseService.getDocumentsByPrefix('organizaciones', prefix);
      if (response.success) {
        final List<Organizacion> organizaciones = [];
        for (Map<String, dynamic> org in response.data) {
          OrganizacionFirestore orgFirestore =
              OrganizacionFirestore.fromMap(org);
          final List<Usuario> miembros =
              await getMembers(orgFirestore.miembros);
          final List<Solicitud> solicitudes = await getRequests(orgFirestore);
          final List<ProyectoFirestore> proyectos =
              await getProjects(orgFirestore.nombre);
          final Usuario owner = await getOwner(orgFirestore.owner['uid'] ?? '');
          Organizacion organizacion = Organizacion(
            nombre: orgFirestore.nombre,
            descripcion: orgFirestore.descripcion,
            proyectos: proyectos,
            solicitudes: solicitudes,
            formulario: orgFirestore.formulario,
            likes: orgFirestore.likes,
            miembros: miembros,
            owner: owner,
            vacantes: orgFirestore.vacantes,
            imageUrl: orgFirestore.imageUrl,
          );
          organizaciones.add(organizacion);
        }
        return Response(
          success: true,
          data: organizaciones,
          message: 'Organizaciones obtenidas correctamente',
        );
      } else {
        return Response(
          success: false,
          message: 'Error al obtener organizaciones',
        );
      }
    } catch (e) {
      _logger.e('Error al obtener organizaciones: $e');
      return Response(
        success: false,
        message: 'Error al obtener organizaciones',
      );
    }
  }

  Future<Response<Organizacion>> createOrganization(
      OrganizacionFirestore organizacion) async {
    try {
      Response response = await _databaseService.addDocument('organizaciones',
          documentId: organizacion.nombre, data: organizacion.toMap());
      if (response.success) {
        _logger.i('Organización creada correctamente');
        String orgName = (response.data);
        // Obtener la data de la organización
        Response<Organizacion> orgResponse = await getData(orgName);
        if (orgResponse.success) {
          return Response(
            success: true,
            data: orgResponse.data,
            message: 'Organización creada correctamente',
          );
        } else {
          return Response(
            success: false,
            message: 'Error al crear organización $orgResponse.message',
          );
        }
      } else {
        return Response(
          success: false,
          message: 'Error al crear organización ${response.message}',
        );
      }
    } catch (e) {
      _logger.e('Error al crear organización: $e');
      return Response(
        success: false,
        message: 'Error al crear organización',
      );
    }
  }
}
