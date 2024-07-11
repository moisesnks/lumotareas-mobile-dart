import 'package:flutter/material.dart';
import 'package:lumotareas/screens/login_screen.dart';
import 'package:lumotareas/services/preferences_service.dart';

import 'logic.dart';
import 'package:lumotareas/widgets/box_label_widget.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:lumotareas/widgets/welcome_title.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final WelcomeScreenLogic _logic = WelcomeScreenLogic();

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  // Método para verificar si se debe redirigir
  Future<bool> checkRedirect() async {
    bool redirectToLogin = await PreferenceService.getRedirectToLogin();
    return redirectToLogin;
  }

  // Método para construir el cuerpo de la pantalla
  Widget renderBody() {
    return Contenedor(
      direction: Axis.vertical,
      children: [
        const Titulo(texto: 'Para comenzar', minFontSize: 18),
        const SizedBox(height: 30),
        BoxLabel(
          labelText: 'Ingresa el nombre de tu organización',
          child: TextField(
            controller: _logic.organizationNameController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Ejemplo: Mi Organización',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 100, 102, 168),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              _logic.handleLoginButtonPress(context);
            },
            child: const Text('¿Ya tienes una cuenta? Inicia sesión')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkRedirect(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se espera la respuesta, puedes mostrar un indicador de carga
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Cuando se obtiene la respuesta, determina qué pantalla mostrar
          if (snapshot.hasError) {
            // Manejar errores si hay algún problema al obtener la redirección
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Si no hay errores, determina si se debe redirigir o mostrar la pantalla actual
            bool shouldRedirect = snapshot.data ??
                false; // Valor por defecto si snapshot.data es null

            if (shouldRedirect) {
              // Redirigir a la pantalla de inicio de sesión y eliminar todas las rutas anteriores
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              });

              // Retornar un contenedor vacío mientras se realiza la redirección
              return Container();
            } else {
              // Mostrar la pantalla actual
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _logic.welcomeImage,
                        ),
                      ),
                      child: Contenedor(
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        direction: Axis.vertical,
                        children: [
                          renderTitle(),
                          const SizedBox(height: 80),
                          renderBody(),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    key: UniqueKey(),
                    shape: const CircleBorder(),
                    onPressed: () {
                      _logic.handleFloatingActionButtonPress(context);
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}
