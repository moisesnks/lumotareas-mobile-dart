import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/welcome_title.dart';

// TODO: arreglarlo para que se parezca a los demás loading
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
              renderTitle2(), // Asegúrate de importar y utilizar renderTitle2 de welcome.dart
              const SizedBox(height: 200),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: const Center(
                  child: Text(
                    'Estamos creando tu organización...',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
