import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/post.dart';
import 'package:lumotareas/services/organization_service.dart';

class DescubrirLogic {
  static Future<List<Organization>> obtenerOrganizacionesDestacadas() async {
    final result = await OrganizationService().getPopularOrganizations();

    if (result['success']) {
      return result['organizations'];
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> likeOrganization(
      String orgName, String uid, bool addLike) async {
    try {
      final result =
          await OrganizationService().likeOrganization(orgName, uid, addLike);

      if (result['success']) {
        return {
          'success': true,
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
        'message': 'Error al dar/quitar like a la organización: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> buscarOrganizaciones(String query) async {
    final result = await OrganizationService().getOrganizationsByPrefix(query);

    if (result['success']) {
      return {
        'success': true,
        'organizations': result['organizations'],
        'message': result['message'],
      };
    } else {
      return {
        'success': false,
        'message': result['message'],
      };
    }
  }

  static List<Post> obtenerPublicacionesRecientes() {
    return [
      Post(
        nombre: 'Usuario 1',
        titulo: 'Título de la publicación 1',
        contenido: 'Contenido de la publicación 1',
        fecha: '2021-10-10',
        imageUrl:
            'https://images.unsplash.com/photo-1606857521015-7f9fcf423740?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        organizationImageUrl: 'assets/organization_logo.png',
        comentarios: 10,
        likes: 5,
      ),
      Post(
        nombre: 'Usuario 2',
        titulo: 'Título de la publicación 2',
        contenido: 'Contenido de la publicación 2',
        fecha: '2021-10-11',
        imageUrl:
            'https://images.unsplash.com/photo-1719917227104-effee8256943?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        organizationImageUrl: 'assets/organization_logo.png',
        comentarios: 20,
        likes: 10,
      ),
      Post(
        nombre: 'Usuario 3',
        titulo: 'Título de la publicación 3',
        contenido: 'Contenido de la publicación 3',
        fecha: '2021-10-12',
        imageUrl: 'assets/post_image.jpg',
        organizationImageUrl: 'assets/organization_logo.png',
        comentarios: 30,
        likes: 15,
      ),
    ];
  }
}
