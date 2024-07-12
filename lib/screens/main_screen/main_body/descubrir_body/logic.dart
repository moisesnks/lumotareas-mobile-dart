import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/post.dart';

class DescubrirLogic {
  static List<Organization> obtenerOrganizacionesDestacadas() {
    return [
      Organization(
        nombre: 'Organización 1',
        miembros: [
          'member1',
          'member2',
          'member3',
          'member4',
          'member5',
        ],
        owner: Owner(nombre: 'Owner 1', uid: 'owner1'),
        vacantes: "true",
        formulario: {},
        descripcion:
            'Descripción de la organización 1 Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1Descripción de la organización 1',
        imageUrl: 'assets/organization_logo.png',
      ),
      Organization(
        nombre: 'Organización 2',
        miembros: [
          'member1',
          'member2',
          'member3',
          'member4',
          'member5',
        ],
        owner: Owner(nombre: 'Owner 2', uid: 'owner2'),
        vacantes: "false",
        formulario: {},
        descripcion: 'Descripción de la organización 2',
        imageUrl: 'assets/organization_logo.png',
      ),
      Organization(
        nombre: 'Organización 3',
        miembros: [
          'member1',
          'member2',
          'member3',
          'member4',
          'member5',
        ],
        owner: Owner(nombre: 'Owner 3', uid: 'owner3'),
        vacantes: "true",
        formulario: {},
        descripcion: 'Descripción de la organización 3',
        imageUrl: 'assets/organization_logo.png',
      ),
    ];
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
