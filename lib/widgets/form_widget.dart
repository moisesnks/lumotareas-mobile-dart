import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/question.dart';
import 'pregunta_page_widget.dart';

class FormWidget extends StatefulWidget {
  final List<Question> preguntas;
  final void Function(Map<String, dynamic> respuestas) onSubmit;

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
      _respuestas[key] = pregunta.tipo == 'seleccion_multiple' ? [] : '';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  bool _allQuestionsAnswered() {
    // Verificar si todas las respuestas han sido completadas
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

  void _updateRespuesta(String key, dynamic value) {
    setState(() {
      if (widget.preguntas[_currentIndex].tipo == 'seleccion_multiple') {
        _respuestas[key] =
            value; // value es List<String> para selección múltiple
      } else if (widget.preguntas[_currentIndex].tipo == 'booleano') {
        _respuestas[key] = value; // value es bool para booleano
      } else {
        _respuestas[key] =
            value.toString(); // value es String para desarrollo (texto)
      }
    });
  }

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

  void _showSnackbar(BuildContext context, String message) {
    // Mostrar snackbar con mensaje
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
