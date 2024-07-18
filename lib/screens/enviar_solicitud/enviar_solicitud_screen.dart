import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization/formulario.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/screens/pregunta_page/widgets/form_widget.dart';
import 'package:provider/provider.dart';

class EnviarSolicitudScreen extends StatelessWidget {
  final String orgName;
  final Formulario formulario;

  const EnviarSolicitudScreen({
    super.key,
    required this.formulario,
    required this.orgName,
  });

  void _handleSubmit(
      BuildContext context, Map<String, dynamic> respuestas) async {
    final Logger logger = Logger();
    logger.d('Respuestas enviadas: $respuestas');

    await Provider.of<UserDataProvider>(context, listen: false)
        .registerSolicitud(context, orgName, respuestas: respuestas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formulario.titulo),
      ),
      body: FormWidget(
        preguntas: formulario.preguntas,
        onSubmit: (respuestas) => _handleSubmit(context, respuestas),
      ),
    );
  }
}
