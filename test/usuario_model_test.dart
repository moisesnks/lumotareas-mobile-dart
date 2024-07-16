import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/models/user/organizaciones.dart';
import 'package:lumotareas/lib/models/user/solicitudes.dart';

void main() {
  group('Usuario', () {
    test('El constructor debería inicializar correctamente', () {
      final usuario = Usuario(
        uid: '1',
        nombre: 'John Doe',
        email: 'john.doe@example.com',
        birthdate: '1990-01-01',
        photoURL: 'https://example.com/photo.jpg',
        currentOrg: 'org1',
        organizaciones: [
          Organizaciones(id: 'org1', nombre: 'Organización 1', isOwner: true),
          Organizaciones(id: 'org2', nombre: 'Organización 2', isOwner: false),
        ],
        solicitudes: [
          Solicitudes(id: 'sol1', orgName: 'Organización 3'),
        ],
      );

      expect(usuario.uid, '1');
      expect(usuario.nombre, 'John Doe');
      expect(usuario.email, 'john.doe@example.com');
      expect(usuario.birthdate, '1990-01-01');
      expect(usuario.photoURL, 'https://example.com/photo.jpg');
      expect(usuario.currentOrg, 'org1');
      expect(usuario.organizaciones.length, 2);
      expect(usuario.solicitudes.length, 1);
    });

    test('fromMap debería convertir correctamente un mapa a un objeto Usuario',
        () {
      final map = {
        'nombre': 'Jane Doe',
        'email': 'jane.doe@example.com',
        'birthdate': '1995-05-05',
        'photoURL': 'https://example.com/jane.jpg',
        'currentOrg': 'org2',
        'organizaciones': [
          {'id': 'org3', 'nombre': 'Organización 3', 'isOwner': false},
        ],
        'solicitudes': [],
      };

      final usuario = Usuario.fromMap('2', map);

      expect(usuario.uid, '2');
      expect(usuario.nombre, 'Jane Doe');
      expect(usuario.email, 'jane.doe@example.com');
      expect(usuario.birthdate, '1995-05-05');
      expect(usuario.photoURL, 'https://example.com/jane.jpg');
      expect(usuario.currentOrg, 'org2');
      expect(usuario.organizaciones.length, 1);
      expect(usuario.solicitudes.length, 0);
    });

    test(
        'isOwnerOf debería verificar correctamente la propiedad de una organización',
        () {
      final usuario = Usuario(
        uid: '1',
        nombre: 'John Doe',
        email: 'john.doe@example.com',
        birthdate: '1990-01-01',
        photoURL: 'https://example.com/photo.jpg',
        currentOrg: 'org1',
        organizaciones: [
          Organizaciones(id: 'org1', nombre: 'Organización 1', isOwner: true),
          Organizaciones(id: 'org2', nombre: 'Organización 2', isOwner: false),
        ],
        solicitudes: [
          Solicitudes(id: 'sol1', orgName: 'Organización 3'),
        ],
      );

      expect(usuario.isOwnerOf('org1'), true);
      expect(usuario.isOwnerOf('org2'), false);
      expect(usuario.isOwnerOf('org3'),
          false); // Organización no presente en la lista
    });

    test('toMap debería generar correctamente un mapa', () {
      final usuario = Usuario(
        uid: '1',
        nombre: 'John Doe',
        email: 'john.doe@example.com',
        birthdate: '1990-01-01',
        photoURL: 'https://example.com/photo.jpg',
        currentOrg: 'org1',
        organizaciones: [
          Organizaciones(id: 'org1', nombre: 'Organización 1', isOwner: true),
          Organizaciones(id: 'org2', nombre: 'Organización 2', isOwner: false),
        ],
        solicitudes: [
          Solicitudes(id: 'sol1', orgName: 'Organización 3'),
        ],
      );

      final map = usuario.toMap();
      expect(map['uid'], '1');
      expect(map['nombre'], 'John Doe');
      expect(map['email'], 'john.doe@example.com');
      expect(map['birthdate'], '1990-01-01');
      expect(map['photoURL'], 'https://example.com/photo.jpg');
      expect(map['currentOrg'], 'org1');

      // Verificar que 'organizaciones' es una lista y que cada elemento es un mapa
      expect(map['organizaciones'], isList);
      expect(map['organizaciones'], [
        {'id': 'org1', 'nombre': 'Organización 1', 'isOwner': true},
        {'id': 'org2', 'nombre': 'Organización 2', 'isOwner': false},
      ]);

      // Verificar que 'solicitudes' es una lista y que cada elemento es un mapa
      expect(map['solicitudes'], isList);
      expect(map['solicitudes'], [
        {'id': 'sol1', 'orgName': 'Organización 3'},
      ]);

      // Verificar que el mapa puede ser convertido correctamente a JSON
      final jsonString = jsonEncode(map);
      expect(jsonString, isNotNull);
    });
  });
}
