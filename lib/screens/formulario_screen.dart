import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:lumotareas/screens/register_screen.dart';

class FormularioScreen extends StatefulWidget {
  final List<dynamic> formulario;
  final String orgName;

  const FormularioScreen(
      {super.key, required this.formulario, required this.orgName});

  @override
  FormularioScreenState createState() => FormularioScreenState();
}

class FormularioScreenState extends State<FormularioScreen> {
  final Logger _logger = Logger();
  final Map<String, String> _respuestas = {};

  @override
  void initState() {
    super.initState();
    for (var element in widget.formulario) {
      if (element is Map<dynamic, dynamic>) {
        for (var key in element.keys) {
          _respuestas[key] = '';
        }
      }
    }
  }

  bool _allQuestionsAnswered() {
    return _respuestas.values.every((respuesta) => respuesta.isNotEmpty);
  }

  Widget _buildFormularioWidgets() {
    return Column(
      children: [
        for (var element in widget.formulario)
          if (element is Map<dynamic, dynamic>) _buildColumnForMap(element),
      ],
    );
  }

  Widget _buildColumnForMap(Map<dynamic, dynamic> element) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var key in element.keys)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: element[key].toString(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _respuestas[key] = value;
                });
              },
            ),
          ),
      ],
    );
  }

  void _showSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Debe rellenar todas las preguntas'),
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
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              const Header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildFormularioWidgets(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _allQuestionsAnswered()
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                        respuestas: _respuestas, orgName: widget.orgName),
                  ),
                );
              }
            : () {
                _showSnackbar(context);
              },
        backgroundColor: _allQuestionsAnswered() ? Colors.blue : Colors.grey,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
