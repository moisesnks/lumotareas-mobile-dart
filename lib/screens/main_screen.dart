import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header2.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});
  final _logger = Logger();

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  DateTime? currentBackPressTime;
  bool redirectToLogin = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    loadRedirectToLogin();
  }

  Future<void> loadRedirectToLogin() async {
    final value = await PreferenceService.getRedirectToLogin();
    setState(() {
      redirectToLogin = value;
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Si no hay un tiempo de prensa de retroceso actual o el tiempo de prensa de retroceso actual es anterior a 2 segundos, entonces
    if (currentBackPressTime == null ||
        DateTime.now().difference(currentBackPressTime!) >
            const Duration(seconds: 2)) {
      currentBackPressTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Presione dos veces hacia atrás para salir'),
        ),
      );
      return true; // Regrese verdadero para detener el evento de botón de retroceso por defecto
    }
    return false; // Devuelve falso para permitir el manejo predeterminado del evento de botón de retroceso
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  await context.read<LoginViewModel>().signOut(context);
                },
                trailing: const Icon(Icons.exit_to_app),
              ),
              SwitchListTile(
                title: const Text('Redirigir a Login'),
                value: redirectToLogin,
                onChanged: (value) async {
                  setState(() {
                    redirectToLogin = value;
                  });
                  await PreferenceService.setRedirectToLogin(value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<LoginViewModel>(
            builder: (context, loginViewModel, child) {
              final currentUser = loginViewModel.currentUser;
              if (currentUser != null) {
                widget._logger.i('Usuario actual: $currentUser');
                return Column(
                  children: [
                    Header(
                      onLogoTap: () {
                        widget._logger.i('Logo tapped!');
                      },
                      onSuffixTap: () {
                        _showBottomSheet(context);
                      },
                      suffixIcon:
                          const Icon(Icons.settings, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bienvenido $currentUser',
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
