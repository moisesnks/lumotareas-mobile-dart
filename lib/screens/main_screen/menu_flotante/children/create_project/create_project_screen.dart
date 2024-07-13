import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/menu_flotante/children/create_project/create_project_logic.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import 'package:lumotareas/widgets/form_widget.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  CreateProjectScreenState createState() => CreateProjectScreenState();
}

class CreateProjectScreenState extends State<CreateProjectScreen> {
  late CreateProjectLogic createProjectLogic;

  @override
  void initState() {
    super.initState();
    createProjectLogic = CreateProjectLogic();
    _initData();
  }

  Future<void> _initData() async {
    await createProjectLogic.initPreguntasCrearProyecto();
    setState(() {}); // Actualiza el estado para reflejar las preguntas cargadas
  }

  @override
  Widget build(BuildContext context) {
    if (createProjectLogic.preguntasCrearProyecto.isEmpty) {
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
                preguntas: createProjectLogic.preguntasCrearProyecto,
                onSubmit: (respuestas) {
                  createProjectLogic.logSubmit(context, respuestas);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
