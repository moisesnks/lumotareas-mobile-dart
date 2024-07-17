import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lumotareas/models/firestore/proyecto.dart';

void main() {
  group('ProyectoFirestore', () {
    test('El constructor debería inicializar correctamente', () {
      final proyecto = ProyectoFirestore(
        id: '1',
        nombre: 'Proyecto 1',
        descripcion: 'Descripción del Proyecto 1',
        asignados: ['user1', 'user2'],
        sprints: ['sprint1', 'sprint2'],
        orgName: 'Organización 1',
        createdBy: 'creator1',
      );

      expect(proyecto.id, '1');
      expect(proyecto.nombre, 'Proyecto 1');
      expect(proyecto.descripcion, 'Descripción del Proyecto 1');
      expect(proyecto.asignados.length, 2);
      expect(proyecto.asignados[0], 'user1');
      expect(proyecto.asignados[1], 'user2');
      expect(proyecto.sprints.length, 2);
      expect(proyecto.sprints[0], 'sprint1');
      expect(proyecto.sprints[1], 'sprint2');
      expect(proyecto.orgName, 'Organización 1');
      expect(proyecto.createdBy, 'creator1');
    });

    test(
        'fromMap debería convertir correctamente un mapa a un objeto ProyectoFirestore',
        () {
      final map = {
        'nombre': 'Proyecto 2',
        'descripcion': 'Descripción del Proyecto 2',
        'asignados': ['user3', 'user4'],
        'sprints': ['sprint3', 'sprint4'],
        'orgName': 'Organización 2',
        'createdBy': 'creator2',
      };

      final proyecto = ProyectoFirestore.fromMap('2', map);

      expect(proyecto.id, '2');
      expect(proyecto.nombre, 'Proyecto 2');
      expect(proyecto.descripcion, 'Descripción del Proyecto 2');
      expect(proyecto.asignados.length, 2);
      expect(proyecto.asignados[0], 'user3');
      expect(proyecto.asignados[1], 'user4');
      expect(proyecto.sprints.length, 2);
      expect(proyecto.sprints[0], 'sprint3');
      expect(proyecto.sprints[1], 'sprint4');
      expect(proyecto.orgName, 'Organización 2');
      expect(proyecto.createdBy, 'creator2');
    });

    test('toMap debería generar correctamente un mapa', () {
      final proyecto = ProyectoFirestore(
        id: '3',
        nombre: 'Proyecto 3',
        descripcion: 'Descripción del Proyecto 3',
        asignados: ['user5', 'user6'],
        sprints: ['sprint5', 'sprint6'],
        orgName: 'Organización 3',
        createdBy: 'creator3',
      );

      final map = proyecto.toMap();
      expect(map['nombre'], 'Proyecto 3');
      expect(map['descripcion'], 'Descripción del Proyecto 3');
      expect(map['asignados'], ['user5', 'user6']);
      expect(map['sprints'], ['sprint5', 'sprint6']);
      expect(map['orgName'], 'Organización 3');
      expect(map['createdBy'], 'creator3');

      // Verificar que el mapa puede ser convertido correctamente a JSON
      final jsonString = jsonEncode(map);
      expect(jsonString, isNotNull);
    });
  });
}
