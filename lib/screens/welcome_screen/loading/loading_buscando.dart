import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/welcome_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';

class BuscandoOrgScreen extends StatelessWidget {
  const BuscandoOrgScreen({super.key});

  final ImageProvider _loadingImage =
      const AssetImage('assets/images/loading.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (_loadingImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Contenedor(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              direction: Axis.vertical,
              children: [
                renderTitle2(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.33),
                const Contenedor(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularProgressIndicator(),
                      Titulo(texto: 'Estamos buscando su organización...'),
                    ])
              ]),
        ),
      ),
    );
  }
}
