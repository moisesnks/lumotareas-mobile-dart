import 'package:flutter/material.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/screens/crear_organizacion/crear_organizacion_preguntas.dart';
import 'package:lumotareas/screens/pregunta_page/widgets/form_widget.dart';
import 'package:lumotareas/widgets/secondary_header.dart';
import 'package:provider/provider.dart';

class CrearOrganizacionScreen extends StatefulWidget {
  const CrearOrganizacionScreen({super.key});

  @override
  CrearOrganizacionScreenState createState() => CrearOrganizacionScreenState();
}

class CrearOrganizacionScreenState extends State<CrearOrganizacionScreen> {
  late CrearOrganizacionPreguntas crearOrganizacionPreguntas;

  @override
  void initState() {
    super.initState();
    Usuario? currentUser =
        Provider.of<UserDataProvider>(context, listen: false).currentUser;
    if (currentUser != null) {
      crearOrganizacionPreguntas =
          CrearOrganizacionPreguntas(currentUser: currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (crearOrganizacionPreguntas.preguntasCrearOrganizacion.isEmpty) {
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
                preguntas:
                    crearOrganizacionPreguntas.preguntasCrearOrganizacion,
                onSubmit: (respuestas) async {
                  crearOrganizacionPreguntas.logSubmit(context, respuestas);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
