import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
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

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              loginViewModel.signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (context, loginViewModel, child) {
            final currentUser = loginViewModel.currentUser;
            if (currentUser != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenido, ${currentUser.email}'),
                  // Aquí colocarías el contenido adicional para usuarios autenticados
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
