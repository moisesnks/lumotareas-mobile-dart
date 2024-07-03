class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String password;
  final String birthdate;
  final Map<String, String>? formulario;
  final List<String>? organizaciones;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.password,
    required this.birthdate,
    this.formulario,
    this.organizaciones,
  });

  // Método para convertir un mapa en una instancia de Usuario
  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'],
      email: map['email'],
      password: map['password'],
      birthdate: map['birthdate'],
      formulario: map['formulario'] != null
          ? Map<String, String>.from(map['formulario'])
          : null,
      organizaciones: map['organizaciones'] != null
          ? List<String>.from(map['organizaciones'])
          : [],
    );
  }

  // Método para convertir una instancia de Usuario en un mapa
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'password': password,
      'birthdate': birthdate,
      'formulario': formulario,
      'organizaciones': organizaciones,
    };
  }
}
