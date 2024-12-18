/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/crear_sprint/crear_sprint_preguntas.dart';
import 'package:lumotareas/widgets/secondary_header.dart';
import 'package:lumotareas/screens/pregunta_page/widgets/form_widget.dart';

class CrearSprintScreen extends StatefulWidget {
  final List<Usuario> miembros;
  final Usuario currentUser;
  final List<String> usuariosAsignados;

  const CrearSprintScreen({
    super.key,
    required this.currentUser,
    required this.miembros,
    required this.usuariosAsignados,
  });

  @override
  CrearSprintScreenState createState() => CrearSprintScreenState();
}

class CrearSprintScreenState extends State<CrearSprintScreen> {
  late CrearSprintPreguntas crearSprintPreguntas;

  @override
  void initState() {
    super.initState();
    crearSprintPreguntas = CrearSprintPreguntas(
        miembrosIds: widget.usuariosAsignados,
        currentOrg: widget.currentUser.currentOrg,
        miembros: widget.miembros,
        currentUser: widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    if (crearSprintPreguntas.preguntasCrearSprint.isEmpty) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Mostrar un indicador de carga mientras se obtienen los datos
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(
              isPoppable: true,
            ),
            Expanded(
              child: FormWidget(
                preguntas: crearSprintPreguntas.preguntasCrearSprint,
                onSubmit: (respuestas) {
                  crearSprintPreguntas.logSubmit(context, respuestas);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
