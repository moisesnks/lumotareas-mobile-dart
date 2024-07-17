import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/firestore/organizacion.dart';
import 'package:lumotareas/models/organization/formulario.dart';
import 'package:lumotareas/models/organization/pregunta.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/organization_data_provider.dart';
import 'package:provider/provider.dart';

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
      ),
      Pregunta(
        enunciado: 'Formulario de la organización',
        tipo: 'formulario',
        required: false,
      )
    ];
  }

  void createOrganizacion(BuildContext context,
      OrganizacionFirestore organizacion, Usuario currentUser) async {
    Logger().i('Creando organización: ${organizacion.nombre}');
    await Provider.of<OrganizationDataProvider>(context, listen: false)
        .createOrganizacion(context, organizacion, currentUser);
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    // Crear la organización en Firestore
    Logger().i('Respuestas: $respuestas');
    String nombre = respuestas['Nombre de la organización'];
    String descripcion = respuestas['Descripción de la organización'];
    bool tieneVacantes = respuestas['¿Tiene vacantes?'];
    // mapear cada elemento del List<dynamic> de respuestas['Formulario de la organización'] a un objeto Pregunta
    List<Pregunta> preguntas = [];
    for (Pregunta pregunta in respuestas['Formulario de la organización']) {
      preguntas.add(pregunta);
    }
    Formulario formulario =
        Formulario(preguntas: preguntas, titulo: 'Formulario para $nombre');

    OrganizacionFirestore organizacion = OrganizacionFirestore(
      nombre: nombre,
      descripcion: descripcion,
      vacantes: tieneVacantes,
      formulario: formulario,
      miembros: [currentUser.uid],
      likes: [],
      owner: {
        'uid': currentUser.uid,
        'nombre': currentUser.nombre,
        'email': currentUser.email,
      },
      proyectos: [],
      imageUrl: '',
    );

    Logger().i('Organización: $organizacion');
    createOrganizacion(context, organizacion, currentUser);
  }
}
