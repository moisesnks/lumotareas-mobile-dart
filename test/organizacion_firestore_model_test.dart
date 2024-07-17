import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lumotareas/models/organization/formulario.dart';
import 'package:lumotareas/models/firestore/organizacion.dart';
import 'package:lumotareas/models/organization/pregunta.dart';

void main() {
  group('OrganizacionFirestore', () {
    test('El constructor debería inicializar correctamente', () {
      final organizacion = OrganizacionFirestore(
        nombre: 'Org 1',
        descripcion: 'Descripción de Org 1',
        likes: ['user1', 'user2'],
        miembros: ['miembro1', 'miembro2'],
        owner: {'uid': 'owner1', 'name': 'Propietario 1'},
        vacantes: true,
        imageUrl: 'https://example.com/image.jpg',
        formulario: Formulario(
          titulo: 'Formulario 1',
          preguntas: <Pregunta>[
            Pregunta(
              enunciado: 'pregunta1',
              tipo: 'tipo1',
              required: true,
              opciones: [Opcion(id: '1', label: 'opcion1')],
              maxLength: 150,
              returnLabel: false,
            ),
            Pregunta(
              enunciado: 'pregunta2',
              tipo: 'tipo2',
              required: false,
              opciones: [],
              maxLength: 150,
              returnLabel: false,
            ),
          ],
        ),
        proyectos: [],
      );

      expect(organizacion.nombre, 'Org 1');
      expect(organizacion.descripcion, 'Descripción de Org 1');
      expect(organizacion.likes.length, 2);
      expect(organizacion.likes[0], 'user1');
      expect(organizacion.likes[1], 'user2');
      expect(organizacion.miembros.length, 2);
      expect(organizacion.miembros[0], 'miembro1');
      expect(organizacion.miembros[1], 'miembro2');
      expect(organizacion.owner['uid'], 'owner1');
      expect(organizacion.owner['name'], 'Propietario 1');
      expect(organizacion.vacantes, true);
      expect(organizacion.imageUrl, 'https://example.com/image.jpg');
      expect(organizacion.formulario.titulo, 'Formulario 1');
      expect(organizacion.formulario.preguntas.length, 2);
      expect(organizacion.formulario.preguntas[0].enunciado, 'pregunta1');
      expect(organizacion.formulario.preguntas[0].tipo, 'tipo1');
      expect(organizacion.formulario.preguntas[0].required, true);
      expect(organizacion.formulario.preguntas[0].opciones?.length, 1);
      expect(organizacion.formulario.preguntas[0].opciones?[0].id, '1');
      expect(
          organizacion.formulario.preguntas[0].opciones?[0].label, 'opcion1');
      expect(organizacion.formulario.preguntas[1].enunciado, 'pregunta2');
      expect(organizacion.formulario.preguntas[1].tipo, 'tipo2');
      expect(organizacion.formulario.preguntas[1].required, false);
      expect(organizacion.formulario.preguntas[1].opciones?.length, 0);
    });

    test(
        'fromMap debería convertir correctamente un mapa a un objeto OrganizacionFirestore',
        () {
      final map = {
        'nombre': 'Org 2',
        'descripcion': 'Descripción de Org 2',
        'likes': ['user3', 'user4'],
        'miembros': ['miembro3', 'miembro4'],
        'owner': {'uid': 'owner2', 'name': 'Propietario 2'},
        'vacantes': false,
        'imageUrl': 'https://example.com/image2.jpg',
        'formulario': {
          'titulo': 'Formulario 2',
          'preguntas': [
            {
              'enunciado': 'pregunta3',
              'tipo': 'tipo3',
              'required': true,
              'opciones': [
                {'id': '2', 'label': 'opcion2'}
              ],
              'maxLength': 200,
              'returnLabel': true,
            },
            {
              'enunciado': 'pregunta4',
              'tipo': 'tipo4',
              'required': false,
              'opciones': [],
              'maxLength': 150,
              'returnLabel': false,
            },
          ],
        },
      };

      final organizacion = OrganizacionFirestore.fromMap(map);

      expect(organizacion.nombre, 'Org 2');
      expect(organizacion.descripcion, 'Descripción de Org 2');
      expect(organizacion.likes.length, 2);
      expect(organizacion.likes[0], 'user3');
      expect(organizacion.likes[1], 'user4');
      expect(organizacion.miembros.length, 2);
      expect(organizacion.miembros[0], 'miembro3');
      expect(organizacion.miembros[1], 'miembro4');
      expect(organizacion.owner['uid'], 'owner2');
      expect(organizacion.owner['name'], 'Propietario 2');
      expect(organizacion.vacantes, false);
      expect(organizacion.imageUrl, 'https://example.com/image2.jpg');
      expect(organizacion.formulario.titulo, 'Formulario 2');
      expect(organizacion.formulario.preguntas.length, 2);
      expect(organizacion.formulario.preguntas[0].enunciado, 'pregunta3');
      expect(organizacion.formulario.preguntas[0].tipo, 'tipo3');
      expect(organizacion.formulario.preguntas[0].required, true);
      expect(organizacion.formulario.preguntas[0].opciones?.length, 1);
      expect(organizacion.formulario.preguntas[0].opciones?[0].id, '2');
      expect(
          organizacion.formulario.preguntas[0].opciones?[0].label, 'opcion2');
      expect(organizacion.formulario.preguntas[1].enunciado, 'pregunta4');
      expect(organizacion.formulario.preguntas[1].tipo, 'tipo4');
      expect(organizacion.formulario.preguntas[1].required, false);
      expect(organizacion.formulario.preguntas[1].opciones?.length, 0);
    });

    test('toMap debería generar correctamente un mapa', () {
      final organizacion = OrganizacionFirestore(
        nombre: 'Org 3',
        descripcion: 'Descripción de Org 3',
        likes: ['user5', 'user6'],
        miembros: ['miembro5', 'miembro6'],
        owner: {'uid': 'owner3', 'name': 'Propietario 3'},
        vacantes: true,
        imageUrl: 'https://example.com/image3.jpg',
        formulario: Formulario(
          titulo: 'Formulario 3',
          preguntas: <Pregunta>[
            Pregunta(
              enunciado: 'pregunta5',
              tipo: 'tipo5',
              required: true,
              opciones: [Opcion(id: '3', label: 'opcion3')],
              maxLength: 100,
              returnLabel: true,
            ),
            Pregunta(
              enunciado: 'pregunta6',
              tipo: 'tipo6',
              required: false,
              opciones: [],
              maxLength: 150,
              returnLabel: false,
            ),
          ],
        ),
        proyectos: [],
      );

      final map = organizacion.toMap();
      expect(map['nombre'], 'Org 3');
      expect(map['descripcion'], 'Descripción de Org 3');
      expect(map['likes'], ['user5', 'user6']);
      expect(map['miembros'], ['miembro5', 'miembro6']);
      expect(map['owner'], {'uid': 'owner3', 'name': 'Propietario 3'});
      expect(map['vacantes'], true);
      expect(map['imageUrl'], 'https://example.com/image3.jpg');
      expect(map['formulario']['titulo'], 'Formulario 3');
      expect(map['formulario']['preguntas'], [
        {
          'enunciado': 'pregunta5',
          'tipo': 'tipo5',
          'required': true,
          'opciones': [
            {'id': '3', 'label': 'opcion3'}
          ],
          'maxLength': 100,
          'returnLabel': true,
        },
        {
          'enunciado': 'pregunta6',
          'tipo': 'tipo6',
          'required': false,
          'opciones': [],
          'maxLength': 150,
          'returnLabel': false,
        },
      ]);

      // Verificar que el mapa puede ser convertido correctamente a JSON
      final jsonString = jsonEncode(map);
      expect(jsonString, isNotNull);
    });
  });
}
