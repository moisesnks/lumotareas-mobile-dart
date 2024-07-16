import '../organization/formulario.dart';

class OrganizacionFirestore {
  String nombre;
  String descripcion;
  List<String> likes;
  List<String> miembros;
  Map<String, String> owner;
  bool vacantes;
  String imageUrl;
  Formulario formulario;

  OrganizacionFirestore({
    required this.nombre,
    required this.descripcion,
    required this.likes,
    required this.miembros,
    required this.owner,
    required this.vacantes,
    required this.imageUrl,
    required this.formulario,
  });

  factory OrganizacionFirestore.fromMap(Map<String, dynamic> map) {
    return OrganizacionFirestore(
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      likes: (map['likes'] as List<dynamic>?)
              ?.map((like) => like.toString())
              .toList() ??
          [],
      miembros: (map['miembros'] as List<dynamic>?)
              ?.map((miembro) => miembro.toString())
              .toList() ??
          [],
      owner: (map['owner'] as Map<String, dynamic>?)?.map((key, value) {
            return MapEntry(key, value.toString());
          }) ??
          {},
      vacantes: map['vacantes'] ?? false,
      imageUrl: map['imageUrl'] ?? '',
      formulario: Formulario.fromMap(map['formulario']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'likes': likes,
      'miembros': miembros,
      'owner': owner,
      'vacantes': vacantes,
      'imageUrl': imageUrl,
      'formulario': formulario.toMap(),
    };
  }

  @override
  String toString() {
    return 'Organizacion: $nombre, Descripción: $descripcion, Likes: $likes, Miembros: $miembros, Owner: $owner, Vacantes: $vacantes, Imagen: $imageUrl, Formulario: $formulario';
  }
}
