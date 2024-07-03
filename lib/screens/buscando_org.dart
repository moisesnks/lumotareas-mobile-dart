import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/welcome_title.dart';

class BuscandoOrgScreen extends StatelessWidget {
  const BuscandoOrgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loading.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
              child: renderTitle2(),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 200), // Añade un margen de 100 al fondo
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Estamos buscando su organización...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
