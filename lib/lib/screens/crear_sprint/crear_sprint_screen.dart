import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/crear_sprint/crear_sprint_preguntas.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';
import 'package:lumotareas/lib/widgets/form_widget.dart';

class CrearSprintScreen extends StatefulWidget {
  final List<Usuario> miembros;
  final Usuario currentUser;

  const CrearSprintScreen({
    super.key,
    required this.currentUser,
    required this.miembros,
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
