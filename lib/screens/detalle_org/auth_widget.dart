import 'package:flutter/material.dart';
import 'package:lumotareas/screens/formulario_screen.dart';
import 'package:lumotareas/screens/login_screen.dart';
import 'package:logger/logger.dart';

class AuthButtons extends StatelessWidget {
  final bool vacantes;
  final List<dynamic> formulario;
  final Logger _logger = Logger(); // Inicializar el logger

  AuthButtons({
    super.key,
    required this.vacantes,
    required this.formulario,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d(
        'Datos recibidos en AuthButtons: vacantes=$vacantes, formulario=$formulario');

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: vacantes
                  ? () {
                      // Navegar a la pantalla de registro con el formulario
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FormularioScreen(formulario: formulario),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                vacantes
                    ? 'Registrarse'
                    : 'Esta organización no recibe solicitudes',
                style: TextStyle(
                  color: vacantes ? Colors.white : Colors.grey[400],
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
