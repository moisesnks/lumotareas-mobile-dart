/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/crear_tarea/crear_tarea_preguntas.dart';
import 'package:lumotareas/lib/widgets/form_widget.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';

class CrearTareaScreen extends StatefulWidget {
  final Usuario currentUser;
  final List<Usuario> miembros;
  final Sprint sprint;

  const CrearTareaScreen({
    super.key,
    required this.miembros,
    required this.sprint,
    required this.currentUser,
  });

  @override
  CrearTareaScreenState createState() => CrearTareaScreenState();
}

class CrearTareaScreenState extends State<CrearTareaScreen> {
  late CrearTareaPreguntas crearTareaPreguntas;

  @override
  void initState() {
    super.initState();
    crearTareaPreguntas = CrearTareaPreguntas(
      currentUser: widget.currentUser,
      sprint: widget.sprint,
      miembros: widget.miembros,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (crearTareaPreguntas.preguntasCrearTarea.isEmpty) {
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
                preguntas: crearTareaPreguntas.preguntasCrearTarea,
                onSubmit: (respuestas) async {
                  crearTareaPreguntas.logSubmit(context, respuestas);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
