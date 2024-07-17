import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumotareas/lib/models/firestore/sprint.dart';

void main() {
  group('SprintFirestore', () {
    test('El constructor debería inicializar correctamente', () {
      final sprint = SprintFirestore(
        id: '1',
        name: 'Sprint 1',
        description: 'Descripción del Sprint 1',
        startDate: Timestamp.fromDate(DateTime(2023, 7, 1)),
        endDate: Timestamp.fromDate(DateTime(2023, 7, 7)),
        projectId: 'project1',
        tasks: ['task1', 'task2'],
        members: ['member1', 'member2'],
        createdBy: 'creator1',
      );

      expect(sprint.id, '1');
      expect(sprint.name, 'Sprint 1');
      expect(sprint.description, 'Descripción del Sprint 1');
      expect(sprint.startDate, Timestamp.fromDate(DateTime(2023, 7, 1)));
      expect(sprint.endDate, Timestamp.fromDate(DateTime(2023, 7, 7)));
      expect(sprint.projectId, 'project1');
      expect(sprint.tasks.length, 2);
      expect(sprint.tasks[0], 'task1');
      expect(sprint.tasks[1], 'task2');
      expect(sprint.members.length, 2);
      expect(sprint.members[0], 'member1');
      expect(sprint.members[1], 'member2');
      expect(sprint.createdBy, 'creator1');
    });

    test(
        'fromMap debería convertir correctamente un mapa a un objeto SprintFirestore',
        () {
      final map = {
        'id': '2',
        'name': 'Sprint 2',
        'description': 'Descripción del Sprint 2',
        'startDate': Timestamp.fromDate(DateTime(2023, 8, 1)),
        'endDate': Timestamp.fromDate(DateTime(2023, 8, 7)),
        'projectId': 'project2',
        'tasks': ['task3', 'task4'],
        'members': ['member3', 'member4'],
        'createdBy': 'creator2',
      };

      final sprint = SprintFirestore.fromMap(map);

      expect(sprint.id, '2');
      expect(sprint.name, 'Sprint 2');
      expect(sprint.description, 'Descripción del Sprint 2');
      expect(sprint.startDate, Timestamp.fromDate(DateTime(2023, 8, 1)));
      expect(sprint.endDate, Timestamp.fromDate(DateTime(2023, 8, 7)));
      expect(sprint.projectId, 'project2');
      expect(sprint.tasks.length, 2);
      expect(sprint.tasks[0], 'task3');
      expect(sprint.tasks[1], 'task4');
      expect(sprint.members.length, 2);
      expect(sprint.members[0], 'member3');
      expect(sprint.members[1], 'member4');
      expect(sprint.createdBy, 'creator2');
    });

    test('toMap debería generar correctamente un mapa', () {
      final sprint = SprintFirestore(
        id: '3',
        name: 'Sprint 3',
        description: 'Descripción del Sprint 3',
        startDate: Timestamp.fromDate(DateTime(2023, 9, 1)),
        endDate: Timestamp.fromDate(DateTime(2023, 9, 7)),
        projectId: 'project3',
        tasks: ['task5', 'task6'],
        members: ['member5', 'member6'],
        createdBy: 'creator3',
      );

      final map = sprint.toMap();
      expect(map['id'], '3');
      expect(map['name'], 'Sprint 3');
      expect(map['description'], 'Descripción del Sprint 3');
      expect(map['startDate'], Timestamp.fromDate(DateTime(2023, 9, 1)));
      expect(map['endDate'], Timestamp.fromDate(DateTime(2023, 9, 7)));
      expect(map['projectId'], 'project3');
      expect(map['tasks'], ['task5', 'task6']);
      expect(map['members'], ['member5', 'member6']);
      expect(map['createdBy'], 'creator3');

      // Convertir a JSON de una manera que maneje los Timestamps
      final jsonString = jsonEncode(map, toEncodable: (value) {
        if (value is Timestamp) {
          return value.millisecondsSinceEpoch;
        }
        return value;
      });

      expect(jsonString, isNotNull);
    });

    test('empty debería inicializar correctamente con valores predeterminados',
        () {
      final sprint = SprintFirestore.empty();

      expect(sprint.id, '');
      expect(sprint.name, '');
      expect(sprint.description, '');
      expect(sprint.startDate, isA<Timestamp>());
      expect(sprint.endDate, isA<Timestamp>());
      expect(sprint.projectId, '');
      expect(sprint.tasks, []);
      expect(sprint.members, []);
      expect(sprint.createdBy, '');
    });

    test(
        'onlyId debería inicializar correctamente con un id y valores predeterminados',
        () {
      final sprint = SprintFirestore.onlyId('4');

      expect(sprint.id, '4');
      expect(sprint.name, '');
      expect(sprint.description, '');
      expect(sprint.startDate, isA<Timestamp>());
      expect(sprint.endDate, isA<Timestamp>());
      expect(sprint.projectId, '');
      expect(sprint.tasks, []);
      expect(sprint.members, []);
      expect(sprint.createdBy, '');
    });
  });
}
