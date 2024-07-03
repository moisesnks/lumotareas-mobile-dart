import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:lumotareas/screens/register_screen.dart'; // Importa la pantalla de registro

class FormularioScreen extends StatelessWidget {
  final List<dynamic> formulario;
  final Logger _logger = Logger(); // Instanciar Logger

  FormularioScreen({super.key, required this.formulario});

  Widget _buildFormularioWidgets() {
    return Column(
      children: [
        for (var element in formulario)
          if (element is Map<dynamic, dynamic>) _buildColumnForMap(element),
      ],
    );
  }

  Widget _buildColumnForMap(Map<dynamic, dynamic> element) {
    return Column(
      children: [
        for (var key in element.keys)
          TextFormField(
            decoration: InputDecoration(
              labelText: element[key].toString(),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Datos recibidos en FormularioScreen: formulario=$formulario');

    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(), // Ocupa toda la pantalla
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
          ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
