import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/welcome_title.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({super.key});
  final Logger _logger = Logger();

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/loading.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              renderTitle2(),
              Text('Contenido de la pantalla de carga'),
            ],
          ),
        ),
      ),
    );
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Lógica para interceptar el botón de retroceso
    widget._logger.i('Botón de retroceso presionado en la pantalla de carga');
    return true; // Devuelve true para detener el evento del botón de retroceso
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
}
