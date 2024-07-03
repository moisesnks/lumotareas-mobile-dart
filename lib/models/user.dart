class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<String>? organizaciones;
  final List<dynamic>? solicitudes;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    this.organizaciones,
    this.solicitudes,
  });

  // Método para convertir un mapa en una instancia de Usuario
  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'],
      email: map['email'],
      birthdate: map['birthdate'],
      organizaciones: map['organizaciones'] != null
          ? List<String>.from(map['organizaciones'])
          : [],
      solicitudes: map['solicitudes'] != null
          ? List<dynamic>.from(map['solicitudes'])
          : [],
    );
  }

  // Método para convertir una instancia de Usuario en un mapa
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'organizaciones': organizaciones,
      'solicitudes': solicitudes,
    };
  }
}
