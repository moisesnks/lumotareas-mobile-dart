//Widget de formulario que permite navegar a través de una lista de preguntas y recopilar respuestas.
library;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Timestamp
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization/pregunta.dart';
import '../pregunta_page_screen.dart';

/// Un widget de formulario que permite navegar a través de una lista de preguntas y recopilar respuestas.
class FormWidget extends StatefulWidget {
  final List<Pregunta> preguntas; // Lista de preguntas en el formulario
  final void Function(Map<String, dynamic> respuestas)
      onSubmit; // Función a llamar al enviar el formulario

  /// Constructor para crear una instancia de [FormWidget].
  ///
  /// [preguntas] es la lista de preguntas en el formulario.
  /// [onSubmit] es la función a llamar al enviar el formulario.
  const FormWidget({
    super.key,
    required this.preguntas,
    required this.onSubmit,
  });

  @override
  FormWidgetState createState() => FormWidgetState();
}

class FormWidgetState extends State<FormWidget> {
  final Logger _logger = Logger();
  late PageController _pageController;
  int _currentIndex = 0;
  late Map<String, dynamic> _respuestas;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _respuestas = {};
    // Inicializar respuestas para cada pregunta
    for (var pregunta in widget.preguntas) {
      var key = pregunta.enunciado.toString();
      if (pregunta.tipo == 'seleccion_multiple') {
        _respuestas[key] = [];
      } else if (pregunta.tipo == 'fecha') {
        _respuestas[key] = Timestamp.now(); // Inicializar con Timestamp actual
      } else if (pregunta.tipo == 'booleano') {
        _respuestas[key] = false; // Inicializar con false (booleano)
      } else if (pregunta.tipo == 'subtareas') {
        _respuestas[key] = []; // Inicializar con lista vacía (subtareas)
      } else if (pregunta.tipo == 'formulario') {
        _respuestas[key] = []; // Inicializar con lista vacía (formulario)
      } else {
        _respuestas[key] = ''; // Otros tipos por defecto vacíos
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Verifica si la pregunta actual ha sido respondida.
  bool _isCurrentQuestionAnswered() {
    var preguntaActual = widget.preguntas[_currentIndex];
    if (preguntaActual.required == true) {
      var respuesta = _respuestas[preguntaActual.enunciado.toString()];
      if (respuesta == '' || (respuesta is List && respuesta.isEmpty)) {
        return false;
      }
    }
    return true;
  }

  /// Verifica si todas las preguntas han sido respondidas.
  bool _allQuestionsAnswered() {
    for (var pregunta in widget.preguntas) {
      if (pregunta.required == true) {
        var respuesta = _respuestas[pregunta.enunciado.toString()];
        if (respuesta == '' || (respuesta is List && respuesta.isEmpty)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Actualiza la respuesta para una pregunta específica.
  ///
  /// [key] es la clave de la pregunta.
  /// [value] es la respuesta proporcionada.
  void _updateRespuesta(String key, dynamic value) {
    setState(() {
      if (widget.preguntas[_currentIndex].tipo == 'seleccion_multiple') {
        _respuestas[key] = value;
      } else if (widget.preguntas[_currentIndex].tipo == 'booleano') {
        _respuestas[key] = value;
      } else if (widget.preguntas[_currentIndex].tipo == 'fecha') {
        if (value is DateTime) {
          _respuestas[key] = Timestamp.fromDate(value);
        } else {
          _respuestas[key] = value;
        }
      } else if (widget.preguntas[_currentIndex].tipo == 'subtareas') {
        _respuestas[key] = value;
      } else if (widget.preguntas[_currentIndex].tipo == 'formulario') {
        _respuestas[key] = value;
      } else {
        _respuestas[key] = value;
      }
    });
  }

  /// Navega a la página siguiente del formulario.
  void _nextPage() {
    if (!_isCurrentQuestionAnswered()) {
      _showSnackbar(context, 'Debe responder la pregunta actual.');
      return;
    }
    if (_currentIndex < widget.preguntas.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (_allQuestionsAnswered()) {
      widget.onSubmit(_respuestas);
    } else {
      _showSnackbar(context, 'Debe rellenar todas las preguntas.');
    }
  }

  /// Navega a la página anterior del formulario.
  void _previousPage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  /// Muestra un Snackbar con un mensaje.
  ///
  /// [context] es el contexto de la aplicación.
  /// [message] es el mensaje a mostrar.
  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Datos recibidos en FormWidget: preguntas=${widget.preguntas}');
    _respuestas.forEach((key, value) {
      _logger.d('Key: $key, Value: $value, Type: ${value.runtimeType}');
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilitar deslizamiento
                itemCount: widget.preguntas.length,
                itemBuilder: (context, index) {
                  var pregunta = widget.preguntas[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PreguntaPage(
                      pregunta: pregunta,
                      respuesta: _respuestas[pregunta.enunciado.toString()],
                      onChanged: (value) =>
                          _updateRespuesta(pregunta.enunciado, value),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentIndex > 0 ? _previousPage : null,
                    child: const Text('Anterior'),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(_currentIndex == widget.preguntas.length - 1
                        ? 'Finalizar'
                        : 'Siguiente'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
