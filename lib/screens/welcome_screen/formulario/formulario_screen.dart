import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/register_form.dart';
import 'package:lumotareas/widgets/header.dart';
import 'pregunta_page.dart';

class FormularioScreen extends StatefulWidget {
  final Map<String, dynamic> formulario;
  final String orgName;

  const FormularioScreen(
      {super.key, required this.formulario, required this.orgName});

  @override
  FormularioScreenState createState() => FormularioScreenState();
}

class FormularioScreenState extends State<FormularioScreen> {
  final Logger _logger = Logger();
  final Map<String, dynamic> _respuestas = {};
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Inicializar respuestas para cada pregunta
    for (var pregunta in widget.formulario['preguntas']) {
      var key = pregunta['enunciado'].toString();
      _respuestas[key] = pregunta['tipo'] == 'seleccion_multiple' ? [] : '';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isCurrentQuestionAnswered() {
    var preguntaActual = widget.formulario['preguntas'][_currentIndex];
    if (preguntaActual['required'] == true) {
      var respuesta = _respuestas[preguntaActual['enunciado'].toString()];
      if (respuesta == '' || (respuesta is List && respuesta.isEmpty)) {
        return false;
      }
    }
    return true;
  }

  bool _allQuestionsAnswered() {
    // Verificar si todas las respuestas han sido completadas
    for (var pregunta in widget.formulario['preguntas']) {
      if (pregunta['required'] == true) {
        var respuesta = _respuestas[pregunta['enunciado'].toString()];
        if (respuesta == '' || (respuesta is List && respuesta.isEmpty)) {
          return false;
        }
      }
    }
    return true;
  }

  void _updateRespuesta(String key, dynamic value) {
    setState(() {
      if (widget.formulario['preguntas'][_currentIndex]['tipo'] ==
          'seleccion_multiple') {
        _respuestas[key] =
            value; // value es List<String> para selección múltiple
      } else {
        _respuestas[key] = value
            .toString(); // value es String para selección única y desarrollo
      }
    });
  }

  void _nextPage() {
    if (!_isCurrentQuestionAnswered()) {
      _showSnackbar(context, 'Debe responder la pregunta actual.');
      return;
    }
    if (_currentIndex < widget.formulario['preguntas'].length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (_allQuestionsAnswered()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RegisterForm(respuestas: _respuestas, orgName: widget.orgName),
        ),
      );
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
    _logger.d(
        'Datos recibidos en FormularioScreen: formulario=${widget.formulario}');
    _logger.d('Respuestas actuales: $_respuestas');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilitar deslizamiento
                itemCount: widget.formulario['preguntas'].length,
                itemBuilder: (context, index) {
                  var pregunta = widget.formulario['preguntas'][index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PreguntaPage(
                      pregunta: pregunta,
                      respuesta: _respuestas[pregunta['enunciado'].toString()],
                      onChanged: (value) => _updateRespuesta(
                          pregunta['enunciado'].toString(), value),
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
                    child: Text(_currentIndex ==
                            widget.formulario['preguntas'].length - 1
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
