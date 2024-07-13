import 'solicitud.dart';
import 'organization.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<OrganizacionUser>? organizaciones;
  final List<SolicitudUser> solicitudes; // Ya no puede ser nulo
  final String photoURL;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    required this.photoURL,
    this.organizaciones,
    this.solicitudes = const [], // Valor predeterminado
  });

  String get getUid => uid;

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      birthdate: map['birthdate'] ?? '',
      photoURL: map['photoURL'] ?? '',
      organizaciones: (map['organizaciones'] as List<dynamic>?)
          ?.map((org) => OrganizacionUser.fromMap(org))
          .toList(),
      solicitudes: (map['solicitudes'] as List<dynamic>?)
              ?.map((sol) => SolicitudUser.fromMap(sol['id'], sol))
              .toList() ??
          [], // Valor predeterminado si es null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'photoURL': photoURL,
      'organizaciones': organizaciones?.map((org) => org.toMap()).toList(),
      'solicitudes': solicitudes
          .map((solicitud) => solicitud.toMap())
          .toList(), // Ya no necesita verificación de null
    };
  }

  List<String> getOwnerOrganizationIds() {
    return organizaciones
            ?.where((org) => org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  List<String> getMemberOrganizationIds() {
    return organizaciones
            ?.where((org) => !org.isOwner)
            .map((org) => org.id)
            .toList() ??
        [];
  }

  bool isOwnerOfOrganization(String organizationId) {
    return organizaciones
            ?.any((org) => org.id == organizationId && org.isOwner) ??
        false;
  }

  @override
  String toString() {
    return 'Usuario{uid: $uid, nombre: $nombre, email: $email, birthdate: $birthdate, organizaciones: $organizaciones, solicitudes: $solicitudes}';
  }
}
