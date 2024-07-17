import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/organizacion.dart';
import 'package:lumotareas/lib/models/organization/formulario.dart';
import 'package:lumotareas/lib/models/organization/pregunta.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class CrearOrganizacionPreguntas {
  List<Pregunta> preguntasCrearOrganizacion = [];
  final Usuario currentUser;

  CrearOrganizacionPreguntas({required this.currentUser}) {
    _initPreguntasCrearOrganizacion();
  }

  void _initPreguntasCrearOrganizacion() {
    // Inicializar las preguntas para crear una organización
    preguntasCrearOrganizacion = [
      Pregunta(
        enunciado: 'Nombre de la organización',
        tipo: 'desarrollo',
        required: true,
        maxLength: 24,
      ),
      Pregunta(
        enunciado: 'Descripción de la organización',
        tipo: 'desarrollo',
        required: true,
        maxLength: 100,
      ),
      Pregunta(
        enunciado: '¿Tiene vacantes?',
        tipo: 'booleano',
        required: false,
      )
    ];
  }

  void createOrganizacion() {
    // Crear la organización en Firestore
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    // Crear la organización en Firestore
    OrganizacionFirestore org = OrganizacionFirestore(
      nombre: respuestas['Nombre de la organización'],
      descripcion: respuestas['Descripción de la organización'],
      vacantes: respuestas['¿Tiene vacantes?'],
      likes: [],
      miembros: [currentUser.uid],
      owner: {
        'uid': currentUser.uid,
        'nombre': currentUser.nombre,
        'email': currentUser.email,
      },
      proyectos: [],
      imageUrl: '',
      formulario: Formulario(
        preguntas: [],
        titulo: 'Formulario para ${respuestas['Nombre de la organización']}',
      ),
    );

    Logger().i('Organización creada: $org');
  }
}
