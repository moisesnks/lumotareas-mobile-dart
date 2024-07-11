import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:lumotareas/widgets/form_widget.dart';
import './logic.dart'; // Importamos logic.dart para manejar la lógica del componente

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
                preguntas: Logic
                    .preguntasCrearProyecto, // Utilizamos las preguntas del Logic
                onSubmit: (respuestas) {
                  String projectName = respuestas['Nombre del Proyecto'] ?? '';
                  String projectDescription =
                      respuestas['Descripción del Proyecto'] ?? '';
                  Logic().logSubmit(projectName,
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
