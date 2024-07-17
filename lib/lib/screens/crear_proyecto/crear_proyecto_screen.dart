import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/widgets/form_widget.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';
import 'package:provider/provider.dart';
import './crear_proyecto_preguntas.dart';

class CrearProyectoScreen extends StatefulWidget {
  const CrearProyectoScreen({
    super.key,
  });

  @override
  CrearProyectoScreenState createState() => CrearProyectoScreenState();
}

class CrearProyectoScreenState extends State<CrearProyectoScreen> {
  late CrearProyectoPreguntas crearProyectoPreguntas;

  @override
  void initState() {
    super.initState();
    final Organizacion currentOrg = Provider.of<OrganizationDataProvider>(
      context,
      listen: false,
    ).organization!;
    crearProyectoPreguntas = CrearProyectoPreguntas(context, currentOrg);
  }

  @override
  Widget build(BuildContext context) {
    if (crearProyectoPreguntas.preguntasCrearProyecto.isEmpty) {
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
                preguntas: crearProyectoPreguntas.preguntasCrearProyecto,
                onSubmit: (respuestas) async {
                  crearProyectoPreguntas.logSubmit(context, respuestas);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
