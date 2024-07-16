import '../user/usuario.dart';
import '../firestore/proyecto.dart';
import '../firestore/solicitud.dart';
import 'formulario.dart';

class Organizacion {
  final String nombre; // Nombre es suficiente para identificar una organización
  final String descripcion; // Descripción de la organización
  final List<ProyectoFirestore>
      proyectos; // Lista de proyectos de la organización
  final List<Solicitud> solicitudes; // Lista de solicitudes de la organización
  final Formulario formulario; // Formulario de la organización
  final List<String> likes;
  final List<Usuario> miembros; // Lista de miembros de la organización
  final Usuario owner; // Dueño de la organización
  final bool vacantes; // Indica si la organización tiene vacantes
  final String imageUrl; // URL de la imagen de la organización

  Organizacion({
    required this.nombre,
    required this.descripcion,
    required this.proyectos,
    required this.solicitudes,
    required this.formulario,
    required this.likes,
    required this.miembros,
    required this.owner,
    required this.vacantes,
    required this.imageUrl,
  });

  factory Organizacion.fromMap(Map<String, dynamic> map) {
    return Organizacion(
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      proyectos: (map['proyectos'] as Map<String, dynamic>?)
              ?.entries
              .map((entry) => ProyectoFirestore.fromMap(entry.key, entry.value))
              .toList() ??
          [],
      solicitudes: (map['solicitudes'] as List<dynamic>?)
              ?.map(
                  (solicitud) => Solicitud.fromMap(solicitud['id'], solicitud))
              .toList() ??
          [],
      formulario: Formulario.fromMap(map['formulario']),
      likes: (map['likes'] as List<dynamic>?)
              ?.map((like) => like.toString())
              .toList() ??
          [],
      miembros: (map['miembros'] as List<dynamic>?)
              ?.map((miembro) => Usuario.fromMap(miembro['uid'], miembro))
              .toList() ??
          [],
      owner: Usuario.fromMap(map['owner']['uid'], map['owner']),
      vacantes: map['vacantes'] ?? false,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'proyectos':
          proyectos.map((proyecto) => MapEntry(proyecto.id, proyecto.toMap())),
      'solicitudes': solicitudes.map((solicitud) => solicitud.toMap()).toList(),
      'formulario': formulario.toMap(),
      'likes': likes,
      'miembros': miembros.map((miembro) => miembro.toMap()).toList(),
      'owner': owner.toMap(),
      'vacantes': vacantes,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Organización: $nombre, Descripción: $descripcion, Proyectos: $proyectos, Solicitudes: $solicitudes, Formulario: $formulario, Likes: $likes, Miembros: $miembros, Owner: $owner, Vacantes: $vacantes, Imagen: $imageUrl';
  }
}
