import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/widgets/welcome_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger _logger = Logger();
  late SharedPreferences _prefs;
  bool _obscurePassword = true; // Estado inicial para ocultar la contraseña
  bool _rememberCredentials =
      false; // Estado inicial para recordar las credenciales

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Método para cargar los valores guardados en SharedPreferences
  void _loadSavedCredentials() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = _prefs.getString('savedEmail') ?? '';
      _passwordController.text = _prefs.getString('savedPassword') ?? '';
      _rememberCredentials = _prefs.getBool('rememberCredentials') ?? false;
    });
  }

  // Método para guardar el último correo y contraseña usados en SharedPreferences
  void _saveCredentials(String email, String password) {
    _prefs.setString('savedEmail', email);
    if (_rememberCredentials) {
      _prefs.setString('savedPassword', password);
    } else {
      _prefs.remove('savedPassword');
    }
  }

  // Método para guardar el estado del checkbox en SharedPreferences
  void _saveRememberCredentials(bool value) {
    _prefs.setBool('rememberCredentials', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final message = viewModel.readMessage();
                  if (message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                    if (message.contains('Inicio de sesión fallido')) {
                      setState(() {
                        _rememberCredentials = false;
                      });
                      _saveRememberCredentials(false); // Guardar estado actual
                    }
                  }
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    renderTitle2(),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Inicio de sesión',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            onChanged: (value) => _saveCredentials(
                                value, _passwordController.text),
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            onChanged: (value) =>
                                _saveCredentials(_emailController.text, value),
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberCredentials,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _rememberCredentials = value;
                                    });
                                    _saveRememberCredentials(
                                        value); // Guardar estado
                                  }
                                },
                              ),
                              const Text('Recordar credenciales'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _logger.d(
                                      'Iniciando sesión...\n Correo: ${_emailController.text}\n Contraseña: ${_passwordController.text}');
                                  viewModel.signInWithEmailAndPassword(
                                      context,
                                      _emailController.text,
                                      _passwordController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text('Iniciar Sesión'),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _logger.d('Iniciando sesión con Google...');
                                  viewModel.signInWithGoogle(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 207, 207),
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
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
