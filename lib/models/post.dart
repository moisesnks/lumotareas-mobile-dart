/// Representa una publicación con atributos específicos.
///
/// Una publicación contiene información como el nombre del autor [nombre],
/// el título de la publicación [titulo], el contenido principal [contenido],
/// la fecha de publicación [fecha], URL de la imagen adjunta [imageUrl],
/// URL de la imagen de la organización [organizationImageUrl],
/// el número de comentarios [comentarios] y el número de likes [likes].
class Post {
  final String nombre;
  final String titulo;
  final String contenido;
  final String fecha;
  final String imageUrl;
  final String organizationImageUrl;
  final int comentarios;
  final int likes;

  /// Constructor para inicializar una publicación con los atributos requeridos.
  Post({
    required this.nombre,
    required this.titulo,
    required this.contenido,
    required this.fecha,
    required this.imageUrl,
    required this.organizationImageUrl,
    required this.comentarios,
    required this.likes,
  });

  /// Constructor de fábrica que crea un objeto [Post] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la publicación.
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      nombre: map['nombre'] ?? '',
      titulo: map['titulo'] ?? '',
      contenido: map['contenido'] ?? '',
      fecha: map['fecha'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      organizationImageUrl: map['organizationImageUrl'] ?? '',
      comentarios: map['comentarios'] ?? 0,
      likes: map['likes'] ?? 0,
    );
  }

  /// Convierte el objeto [Post] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la publicación se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': fecha,
      'imageUrl': imageUrl,
      'organizationImageUrl': organizationImageUrl,
      'comentarios': comentarios,
      'likes': likes,
    };
  }

  /// Sobrescribe el método toString para proporcionar una representación en cadena del objeto [Post].
  @override
  String toString() {
    return 'Post: $titulo\nNombre: $nombre\nContenido: $contenido\nFecha: $fecha\nImagen: $imageUrl\nImagen de la organización: $organizationImageUrl\nComentarios: $comentarios\nLikes: $likes';
  }
}
