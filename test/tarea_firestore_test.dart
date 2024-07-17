import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumotareas/models/firestore/comentarios.dart';
import 'package:lumotareas/models/firestore/logs.dart';
import 'package:lumotareas/models/firestore/small_user.dart';
import 'package:lumotareas/models/firestore/subtarea.dart';
import 'package:lumotareas/models/firestore/tareas.dart';

void main() {
  group('TareaFirestore', () {
    test('El constructor debería inicializar correctamente', () {
      final tarea = TareaFirestore(
        id: '1',
        name: 'Tarea 1',
        description: 'Descripción de la Tarea 1',
        startDate: Timestamp.fromDate(DateTime(2023, 7, 1)),
        endDate: Timestamp.fromDate(DateTime(2023, 7, 7)),
        subtareas: [
          Subtarea(
              id: 'sub1',
              name: 'Subtarea 1',
              description: 'Desc 1',
              done: false),
          Subtarea(
              id: 'sub2',
              name: 'Subtarea 2',
              description: 'Desc 2',
              done: false),
        ],
        asignados: ['user1', 'user2'],
        comentarios: [
          Comentarios(
            message: 'Comentario 1',
            user:
                SmallUser(uid: 'user1', nombre: 'Usuario 1', photoUrl: 'url1'),
            fecha: Timestamp.fromDate(DateTime(2023, 7, 2)),
          ),
        ],
        logs: [
          Logs(
              uid: 'user1',
              message: 'Log 1',
              timestamp: Timestamp.fromDate(DateTime(2023, 7, 3))),
        ],
        private: false,
        sprintId: 'sprint1',
        projectId: 'project1',
        createdBy: 'creator1',
        visible: false,
      );

      expect(tarea.id, '1');
      expect(tarea.name, 'Tarea 1');
      expect(tarea.description, 'Descripción de la Tarea 1');
      expect(tarea.startDate, Timestamp.fromDate(DateTime(2023, 7, 1)));
      expect(tarea.endDate, Timestamp.fromDate(DateTime(2023, 7, 7)));
      expect(tarea.subtareas.length, 2);
      expect(tarea.subtareas[0].id, 'sub1');
      expect(tarea.subtareas[1].id, 'sub2');
      expect(tarea.asignados.length, 2);
      expect(tarea.asignados[0], 'user1');
      expect(tarea.asignados[1], 'user2');
      expect(tarea.comentarios.length, 1);
      expect(tarea.comentarios[0].message, 'Comentario 1');
      expect(tarea.logs.length, 1);
      expect(tarea.logs[0].message, 'Log 1');
      expect(tarea.private, false);
      expect(tarea.sprintId, 'sprint1');
      expect(tarea.projectId, 'project1');
      expect(tarea.createdBy, 'creator1');
      expect(tarea.visible, false);
    });

    test(
        'fromMap debería convertir correctamente un mapa a un objeto TareaFirestore',
        () {
      final map = {
        'name': 'Tarea 2',
        'description': 'Descripción de la Tarea 2',
        'startDate': Timestamp.fromDate(DateTime(2023, 8, 1)),
        'endDate': Timestamp.fromDate(DateTime(2023, 8, 7)),
        'subtareas': [
          {
            'id': 'sub3',
            'name': 'Subtarea 3',
            'description': 'Desc 3',
            'done': false,
            'completedBy': '',
          },
          {
            'id': 'sub4',
            'name': 'Subtarea 4',
            'description': 'Desc 4',
            'done': false,
            'completedBy': '',
          },
        ],
        'asignados': ['user3', 'user4'],
        'comentarios': [
          {
            'message': 'Comentario 2',
            'user': {'uid': 'user3', 'nombre': 'Usuario 3', 'photoUrl': 'url3'},
            'fecha': Timestamp.fromDate(DateTime(2023, 8, 2)),
          },
        ],
        'logs': [
          {
            'uid': 'user3',
            'message': 'Log 2',
            'timestamp': Timestamp.fromDate(DateTime(2023, 8, 3)),
          },
        ],
        'private': false,
        'sprintId': 'sprint2',
        'projectId': 'project2',
        'createdBy': 'creator2',
        'visible': false,
      };

      final tarea = TareaFirestore.fromMap('2', map);

      expect(tarea.id, '2');
      expect(tarea.name, 'Tarea 2');
      expect(tarea.description, 'Descripción de la Tarea 2');
      expect(tarea.startDate, Timestamp.fromDate(DateTime(2023, 8, 1)));
      expect(tarea.endDate, Timestamp.fromDate(DateTime(2023, 8, 7)));
      expect(tarea.subtareas.length, 2);
      expect(tarea.subtareas[0].id, 'sub3');
      expect(tarea.subtareas[1].id, 'sub4');
      expect(tarea.asignados.length, 2);
      expect(tarea.asignados[0], 'user3');
      expect(tarea.asignados[1], 'user4');
      expect(tarea.comentarios.length, 1);
      expect(tarea.comentarios[0].message, 'Comentario 2');
      expect(tarea.logs.length, 1);
      expect(tarea.logs[0].message, 'Log 2');
      expect(tarea.private, false);
      expect(tarea.sprintId, 'sprint2');
      expect(tarea.projectId, 'project2');
      expect(tarea.createdBy, 'creator2');
      expect(tarea.visible, false);
    });

    test('toMap debería generar correctamente un mapa', () {
      final tarea = TareaFirestore(
        id: '3',
        name: 'Tarea 3',
        description: 'Descripción de la Tarea 3',
        startDate: Timestamp.fromDate(DateTime(2023, 9, 1)),
        endDate: Timestamp.fromDate(DateTime(2023, 9, 7)),
        subtareas: [
          Subtarea(
              id: 'sub5',
              name: 'Subtarea 5',
              description: 'Desc 5',
              done: false),
          Subtarea(
              id: 'sub6',
              name: 'Subtarea 6',
              description: 'Desc 6',
              done: false),
        ],
        asignados: ['user5', 'user6'],
        comentarios: [
          Comentarios(
            message: 'Comentario 3',
            user:
                SmallUser(uid: 'user5', nombre: 'Usuario 5', photoUrl: 'url5'),
            fecha: Timestamp.fromDate(DateTime(2023, 9, 2)),
          ),
        ],
        logs: [
          Logs(
              uid: 'user5',
              message: 'Log 3',
              timestamp: Timestamp.fromDate(DateTime(2023, 9, 3))),
        ],
        private: false,
        sprintId: 'sprint3',
        projectId: 'project3',
        createdBy: 'creator3',
        visible: false,
      );

      final map = tarea.toMap();
      expect(map['name'], 'Tarea 3');
      expect(map['description'], 'Descripción de la Tarea 3');
      expect(map['startDate'], isA<Timestamp>());
      expect(map['endDate'], isA<Timestamp>());
      expect(map['subtareas'], [
        {
          'id': 'sub5',
          'name': 'Subtarea 5',
          'description': 'Desc 5',
          'done': false,
          'completedBy': '',
        },
        {
          'id': 'sub6',
          'name': 'Subtarea 6',
          'description': 'Desc 6',
          'done': false,
          'completedBy': '',
        },
      ]);
      expect(map['asignados'], ['user5', 'user6']);
      expect(map['comentarios'], [
        {
          'message': 'Comentario 3',
          'user': {'uid': 'user5', 'nombre': 'Usuario 5', 'photoUrl': 'url5'},
          'fecha': Timestamp.fromDate(DateTime(2023, 9, 2)),
        },
      ]);
      expect(map['logs'], [
        {
          'uid': 'user5',
          'message': 'Log 3',
          'timestamp': Timestamp.fromDate(DateTime(2023, 9, 3)),
        },
      ]);
      expect(map['private'], false);
      expect(map['sprintId'], 'sprint3');
      expect(map['projectId'], 'project3');
      expect(map['createdBy'], 'creator3');
      expect(map['visible'], false);

      // Convertir a JSON de una manera que maneje los Timestamps
      final jsonString = jsonEncode(map, toEncodable: (value) {
        if (value is Timestamp) {
          return value.millisecondsSinceEpoch;
        }
        return value;
      });

      expect(jsonString, isNotNull);
    });
  });
}
