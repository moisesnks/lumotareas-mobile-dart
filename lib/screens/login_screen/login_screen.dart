import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/widgets/welcome_title.dart';
import '../register_screen/register_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/no-org.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Contenedor(
                    height: MediaQuery.of(context).size.height,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      renderTitle2(),
                      Contenedor(
                        height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.only(
                            top: 100, left: 16, right: 16, bottom: 16),
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Contenedor(
                            height: MediaQuery.of(context).size.height * 0.5,
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Contenedor(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                  const Text(
                                    'Inicia sesión con tu cuenta de Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _logger
                                          .d('Iniciando sesión con Google...');
                                      viewModel.signInWithGoogle(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 207, 207, 207),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/images/google-svgrepo.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    label: const Text(
                                      'Continuar con Google',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _logger.d('Registrarme presionado');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterFormWidget(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      '¿No tienes una cuenta? Regístrate',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // Registrarme es un textbutton que lleva a la pantalla de registro
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
