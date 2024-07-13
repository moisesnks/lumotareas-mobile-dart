import 'package:flutter/material.dart';
import 'package:lumotareas/models/question.dart';
import 'package:lumotareas/screens/register_form.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import 'package:lumotareas/widgets/form_widget.dart';
import 'package:logger/logger.dart';

class FormularioScreen extends StatelessWidget {
  final Map<String, dynamic> formulario;
  final String orgName;
  final Logger _logger = Logger();

  FormularioScreen({
    super.key,
    required this.formulario,
    required this.orgName,
  });

  @override
  Widget build(BuildContext context) {
    List<Question> preguntas = formulario['preguntas']
        .map<Question>((pregunta) => Question.fromMap(pregunta))
        .toList();
    _logger.i('Se cargaron las preguntas del formulario $preguntas con éxito.');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: FormWidget(
                preguntas: preguntas,
                onSubmit: (respuestas) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterFormWidget(
                          respuestas: respuestas, orgName: orgName),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
