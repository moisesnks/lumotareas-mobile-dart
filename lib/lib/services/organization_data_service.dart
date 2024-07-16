import 'package:lumotareas/lib/models/organization/proyectos.dart';
import 'package:lumotareas/lib/models/organization/solicitud.dart';
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