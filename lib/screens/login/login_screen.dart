import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/login/login_titulo.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/no-org.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) => authProvider.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginTitulo(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    ElevatedButton.icon(
                      onPressed: () {
                        Logger().d('Iniciando sesión con Google...');
                        authProvider.loginWithGoogle(context);
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
