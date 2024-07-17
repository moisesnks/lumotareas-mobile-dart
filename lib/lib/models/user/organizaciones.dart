/// @nodoc
library;
class Organizaciones {
  final String id;
  final String nombre;
  final bool isOwner;

  Organizaciones({
    required this.id,
    required this.nombre,
    this.isOwner = false,
  });

  factory Organizaciones.fromMap(Map<String, dynamic> map) {
    return Organizaciones(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      isOwner: map['isOwner'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'isOwner': isOwner,
    };
  }

  @override
  String toString() {
    return 'Organizaciones{id: $id, nombre: $nombre} isOwner: $isOwner';
  }
}
