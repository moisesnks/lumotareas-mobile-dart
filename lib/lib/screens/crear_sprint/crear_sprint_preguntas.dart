import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/sprint.dart';
import 'package:lumotareas/lib/models/organization/pregunta.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:provider/provider.dart';

class CrearSprintPreguntas {
  List<Pregunta> preguntasCrearSprint = [];
  final List<Usuario> miembros;
  final String currentOrg;

  CrearSprintPreguntas({required this.currentOrg, required this.miembros}) {
    _initPreguntasCrearSprint();
  }

  void _initPreguntasCrearSprint() {
    preguntasCrearSprint = [
      Pregunta(
        enunciado: 'Nombre del sprint',
        tipo: 'desarrollo',
        required: true,
        maxLength: 25,
      ),
      Pregunta(
        enunciado: 'Descripción del sprint',
        tipo: 'desarrollo',
        required: true,
        maxLength: 100,
      ),
      Pregunta(
        enunciado: 'Fecha de inicio',
        tipo: 'fecha',
        required: true,
      ),
      Pregunta(
        enunciado: 'Fecha de fin',
        tipo: 'fecha',
        required: true,
      ),
      Pregunta(
        enunciado: 'Miembros asignados',
        tipo: 'seleccion_multiple',
        required: true,
        opciones: miembros
            .map((usuario) => Opcion(
                  id: usuario.uid,
                  label: usuario.nombre,
                ))
            .toList(),
      ),
    ];
  }

  void createSprint(BuildContext context, SprintFirestore sprint) async {
    if (context.mounted) {
      Navigator.pushNamed(context, '/loading', arguments: 'Creando sprint...');
    }

    await Provider.of<ProjectDataProvider>(context, listen: false)
        .addSprint(context, sprint);

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);

      Logger().i('Sprint creado, volviendo a la pantalla anterior');
    }
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    // Implementación de logSubmit
    Logger().i('Respuestas: $respuestas');
    // Convertir las respuestas a un objeto Sprint
    SprintFirestore sprint = SprintFirestore(
      id: respuestas['Nombre del sprint'],
      name: respuestas['Nombre del sprint'],
      description: respuestas['Descripción del sprint'],
      startDate: respuestas['Fecha de inicio'] as Timestamp,
      endDate: respuestas['Fecha de fin'] as Timestamp,
      members: respuestas['Miembros asignados'],
      projectId: currentOrg,
      tasks: [],
    );

    Logger().i('Sprint Firestore: ${sprint.toMap()}');

    createSprint(context, sprint);
    Navigator.pop(context);

    Logger().i('Sprint creado, ha terminado el proceso');
  }
}
