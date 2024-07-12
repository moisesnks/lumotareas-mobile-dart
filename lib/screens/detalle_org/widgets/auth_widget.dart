import 'package:flutter/material.dart';
import 'package:lumotareas/screens/welcome_screen/formulario/formulario_screen.dart';
import 'package:lumotareas/screens/login_screen/login_screen.dart';

class AuthButtons extends StatelessWidget {
  final bool vacantes;
  final String orgName;
  final Map<String, dynamic> formulario;

  const AuthButtons({
    super.key,
    required this.vacantes,
    required this.formulario,
    required this.orgName,
  });

  bool get isVacantes => vacantes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: isVacantes
                    ? () {
                        // Navegar a la pantalla de registro con el formulario
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioScreen(
                                formulario: formulario, orgName: orgName),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isVacantes
                        ? const Icon(Icons.person_add, color: Colors.white)
                        : Icon(Icons.block, color: Colors.grey[400]),
                    const SizedBox(width: 8.0),
                    Text(
                      isVacantes
                          ? 'Registrarse'
                          : 'Esta organización no recibe solicitudes',
                      style: TextStyle(
                        color: isVacantes ? Colors.white : Colors.grey[400],
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
