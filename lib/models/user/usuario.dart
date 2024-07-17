/// @nodoc
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumotareas/models/user/organizaciones.dart';
import 'package:lumotareas/models/user/solicitudes.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String birthdate;
  final List<Organizaciones> organizaciones;
  final List<Solicitudes> solicitudes;
  final String photoURL;
  final String currentOrg;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.birthdate,
    required this.photoURL,
    required this.currentOrg,
    this.organizaciones = const [],
    this.solicitudes = const [],
  });

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      birthdate: map['birthdate'] ?? '',
      photoURL: map['photoURL'] ?? '',
      organizaciones: (map['organizaciones'] as List<dynamic>?)
              ?.map((org) => Organizaciones.fromMap(org))
              .toList() ??
          [],
      solicitudes: (map['solicitudes'] as List<dynamic>?)
              ?.map((sol) => Solicitudes.fromMap(sol))
              .toList() ??
          [],
      currentOrg: map['currentOrg'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'birthdate': birthdate,
      'photoURL': photoURL,
      'organizaciones': organizaciones.map((org) => org.toMap()).toList(),
      'solicitudes': solicitudes.map((sol) => sol.toMap()).toList(),
      'currentOrg': currentOrg,
    };
  }

  bool isOwnerOf(String orgId) {
    return organizaciones
        .firstWhere((org) => org.id == orgId,
            orElse: () => Organizaciones(id: '', nombre: ''))
        .isOwner;
  }

  bool hasOrganization() {
    return organizaciones.isNotEmpty;
  }

  @override
  String toString() {
    return 'Usuario(uid: $uid, nombre: $nombre, email: $email, birthdate: $birthdate, organizaciones: $organizaciones, solicitudes: $solicitudes, photoURL: $photoURL)';
  }

  factory Usuario.fromFirebaseUser(User firebaseUser) {
    return Usuario(
      uid: firebaseUser.uid,
      nombre: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      birthdate: '',
      photoURL: firebaseUser.photoURL ?? '',
      currentOrg: '',
    );
  }

  factory Usuario.empty() {
    return Usuario(
      uid: '',
      nombre: '',
      email: '',
      birthdate: '',
      photoURL: '',
      currentOrg: '',
    );
  }

  Usuario copyWith({
    String? uid,
    String? nombre,
    String? email,
    String? birthdate,
    String? photoURL,
    String? currentOrg,
    List<Organizaciones>? organizaciones,
    List<Solicitudes>? solicitudes,
  }) {
    return Usuario(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
      photoURL: photoURL ?? this.photoURL,
      currentOrg: currentOrg ?? this.currentOrg,
      organizaciones: organizaciones ?? this.organizaciones,
      solicitudes: solicitudes ?? this.solicitudes,
    );
  }
}
