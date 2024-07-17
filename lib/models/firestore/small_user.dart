//Modelo de Información del usuario (small user)
library;

/// Clase que representa un usuario con información mínima.
class SmallUser {
  final String uid;
  final String nombre;
  final String photoUrl;

  /// Constructor para crear una instancia de [SmallUser].
  ///
  /// [uid] es el identificador del usuario.
  /// [nombre] es el nombre del usuario.
  /// [photoUrl] es la URL de la foto del usuario.
  SmallUser({
    required this.uid,
    required this.nombre,
    required this.photoUrl,
  });

  /// Crea una instancia de [SmallUser] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos del usuario.
  factory SmallUser.fromMap(Map<String, dynamic> map) {
    return SmallUser(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  /// Convierte una instancia de [SmallUser] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'Usuario: UID: $uid, Nombre: $nombre, Foto: $photoUrl';
  }
}
