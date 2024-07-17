import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/login/login_titulo.dart';
import 'package:lumotareas/widgets/birthdate_picker.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  late DateTime _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _selectedBirthDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/new_org.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) => authProvider.isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Registrando...'),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginTitulo(),
                    const Text('Ingresa tu fecha de nacimiento'),
                    BirthdatePicker(
                      upperLimit: DateTime.now()
                          .subtract(const Duration(days: 365 * 18)),
                      lowerLimit: DateTime.now()
                          .subtract(const Duration(days: 365 * 100)),
                      dateChangedCallback: (date) {
                        setState(() {
                          _selectedBirthDate = date;
                        });
                        Logger().d('Fecha de nacimiento: $date');
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    ElevatedButton.icon(
                      onPressed: () {
                        Logger().d('Registrando con Google...');
                        // Formatear la fecha seleccionada como string
                        String birthDate =
                            '${_selectedBirthDate.day}-${_selectedBirthDate.month}-${_selectedBirthDate.year}';
                        authProvider.registerWithGoogle(context,
                            birthDate: birthDate);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
      ),
    );
  }
}
