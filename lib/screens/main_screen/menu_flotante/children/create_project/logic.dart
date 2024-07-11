import 'package:logger/logger.dart';

class Logic {
  // Define las preguntas para crear un proyecto
  static const List<Map<String, dynamic>> preguntasCrearProyecto = [
    {
      'enunciado': 'Nombre del Proyecto',
      'tipo': 'desarrollo',
      'required': true,
      'max_length': 16,
    },
    {
      'enunciado': 'Descripción del Proyecto',
      'tipo': 'desarrollo',
      'required': true,
    },
  ];

  final Logger _logger = Logger();

  void logSubmit(String projectName, String projectDescription) {
    _logger.d('Proyecto creado: $projectName');
    _logger.d('Descripción del proyecto: $projectDescription');
    // Aquí puedes agregar más lógica según sea necesario
  }
}
