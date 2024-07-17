import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/firestore/solicitud.dart';
import 'package:lumotareas/lib/models/response.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/services/database_service.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/models/firestore/organizacion.dart';

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
}
