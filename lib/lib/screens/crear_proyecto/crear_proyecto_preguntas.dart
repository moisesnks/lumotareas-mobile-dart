import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/models/organization/pregunta.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class CrearProyectoPreguntas {
  Usuario? currentUser;
  List<Pregunta> preguntasCrearProyecto = [];
  List<Usuario> usuariosAsignados = [];

  CrearProyectoPreguntas(BuildContext context, Organizacion organizacion) {
    _initPreguntasCrearProyecto(context, organizacion);
  }

  void _initPreguntasCrearProyecto(
      BuildContext context, Organizacion organizacion) {
    currentUser =
        Provider.of<UserDataProvider>(context, listen: false).currentUser;
    usuariosAsignados = organizacion.miembros;

    // Inicializar las preguntas para crear un proyecto
    preguntasCrearProyecto = [
      Pregunta(
        enunciado: 'Nombre del proyecto',
        tipo: 'desarrollo',
        required: true,
        maxLength: 16,
      ),
      Pregunta(
        enunciado: 'Descripción del proyecto',
        tipo: 'desarrollo',
        required: true,
        maxLength: 100,
      ),
      Pregunta(
        enunciado: 'Miembros del proyecto',
        tipo: 'seleccion_multiple',
        required: true,
        opciones: usuariosAsignados
            .map((usuario) => Opcion(
                  id: usuario.uid,
                  label: usuario.nombre,
                ))
            .toList(),
      ),
    ];
  }

  void createProyecto(BuildContext context, ProyectoFirestore proyecto) {
    // Crear la tarea en Firestore
    Provider.of<OrganizationDataProvider>(context, listen: false)
        .createProyecto(context, proyecto);

    Provider.of<OrganizationDataProvider>(context, listen: false)
        .fetchOrganization(context, proyecto.orgName, forceFetch: true);
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    Logger().i('Respuestas: $respuestas');

    // Crear el proyecto con las respuestas
    ProyectoFirestore proyecto = ProyectoFirestore(
      id: respuestas['Nombre del proyecto'].split(' ').join('_'),
      nombre: respuestas['Nombre del proyecto'],
      descripcion: respuestas['Descripción del proyecto'],
      orgName: currentUser!.currentOrg,
      asignados: respuestas['Miembros del proyecto'],
      sprints: [],
      createdBy: currentUser!.uid,
    );

    // Guardar el proyecto en Firestore
    createProyecto(context, proyecto);
  }
}
