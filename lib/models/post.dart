class Post {
  final String nombre;
  final String titulo;
  final String contenido;
  final String fecha;
  final String imageUrl;
  final String organizationImageUrl;
  final int comentarios;
  final int likes;

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

  @override
  String toString() {
    return 'Post: $titulo\nNombre: $nombre\nContenido: $contenido\nFecha: $fecha\nImagen: $imageUrl\nImagen de la organización: $organizationImageUrl\nComentarios: $comentarios\nLikes: $likes';
  }
}
