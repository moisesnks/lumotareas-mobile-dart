import 'package:logger/logger.dart';
import 'package:lumotareas/models/question.dart';
// ignore: unused_import
import 'package:lumotareas/models/project.dart';

class CreateProjectLogic {
  // Define las preguntas para crear un proyecto
  static List<Question> preguntasCrearProyecto = [
    Question(
      enunciado: 'Nombre del Proyecto',
      tipo: 'desarrollo',
      required: true,
      maxLength: 16,
    ),
    Question(
      enunciado: 'Descripción del Proyecto',
      tipo: 'desarrollo',
      required: true,
    ),
  ];

  final Logger _logger = Logger();

  void logSubmit(String projectName, String projectDescription) {
    _logger.d('Proyecto creado: $projectName');
    _logger.d('Descripción del proyecto: $projectDescription');
    // Aquí puedes agregar más lógica según sea necesario
  }
}
