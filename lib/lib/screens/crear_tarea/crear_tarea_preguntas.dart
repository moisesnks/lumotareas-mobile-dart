import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/organization/pregunta.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:provider/provider.dart';

class CrearTareaPreguntas {
  List<Pregunta> preguntasCrearTarea = [];
  final List<Usuario> miembros;
  final Sprint sprint;

  CrearTareaPreguntas({required this.sprint, required this.miembros}) {
    _initPreguntasCrearSprint();
  }

  void _initPreguntasCrearSprint() {
    preguntasCrearTarea = [
      Pregunta(
        enunciado: 'Nombre de la tarea',
        tipo: 'desarrollo',
        required: true,
        maxLength: 16,
      ),
      Pregunta(
        enunciado: 'Descripción de la tarea',
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
      Pregunta(
        enunciado: 'Subtareas',
        tipo: 'subtareas',
        required: false,
      ),
    ];
  }

  void createTarea(BuildContext context, TareaFirestore tarea) async {
    Navigator.pushNamed(context, '/loading', arguments: 'Creando tarea...');

    await Provider.of<ProjectDataProvider>(context, listen: false)
        .addTarea(sprint.sprintFirestore, tarea);

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    Logger().d('Respuestas: $respuestas');

    String nombre = respuestas['Nombre de la tarea'];
    String descripcion = respuestas['Descripción de la tarea'];
    Timestamp fechaInicio = (respuestas['Fecha de inicio']);
    Timestamp fechaFin = (respuestas['Fecha de fin']);
    List<String> miembros = respuestas['Miembros asignados'];
    List<dynamic> subtareas = respuestas['Subtareas'];

    Logger().i('Subtareas: $subtareas');

    List<Subtarea> subtareasList = [];

    for (int i = 0; i < subtareas.length; i++) {
      Subtarea subtarea = subtareas[i];
      subtareasList.add(Subtarea(
        id: 'subtarea_$i',
        name: subtarea.name,
        done: false,
        description: subtarea.description,
      ));
    }

    TareaFirestore tarea = TareaFirestore(
      id: DateTime.now().millisecondsSinceEpoch.toString().replaceAllMapped(
          RegExp(r'.'),
          (match) =>
              '${match.group(0)}${String.fromCharCode(97 + Random().nextInt(26))}'),
      name: nombre,
      description: descripcion,
      startDate: fechaInicio,
      endDate: fechaFin,
      asignados: miembros,
      subtareas: subtareasList,
      sprintId: sprint.sprintFirestore.id,
      projectId: sprint.sprintFirestore.projectId,
    );

    Logger().i('Tarea: $tarea');

    createTarea(context, tarea);
  }
}
