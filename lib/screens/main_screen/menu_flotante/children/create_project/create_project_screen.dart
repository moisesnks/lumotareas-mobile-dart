import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/menu_flotante/children/create_project/create_project_logic.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import 'package:lumotareas/widgets/form_widget.dart';

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: FormWidget(
                preguntas: CreateProjectLogic
                    .preguntasCrearProyecto, // Utilizamos las preguntas del CreateProjectLogic
                onSubmit: (respuestas) {
                  String projectName = respuestas['Nombre del Proyecto'] ?? '';
                  String projectDescription =
                      respuestas['Descripción del Proyecto'] ?? '';
                  CreateProjectLogic().logSubmit(projectName,
                      projectDescription); // Logging después del submit
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
