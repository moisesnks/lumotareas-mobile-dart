import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumotareas/screens/organization_screen.dart';
import 'package:lumotareas/widgets/arrow_circle.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _orgController = TextEditingController();

  HomeScreen({super.key});

  Widget renderColumnTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola! Bienvenido a',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFFFFFFFF),
            height: 1,
          ),
        ),
        Text(
          'Lumotareas ',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color(0xFFFFFFFF),
            height: 1,
          ),
        ),
        Text(
          'Todo el potencial de un equipo ágil al alcance de tu móvil',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Color(0xFFC9B8F9),
          ),
        ),
      ],
    );
  }

  Widget renderLogo() {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: 72,
      height: 72,
    );
  }

  Widget renderTitle() {
    return Row(
      children: [
        const SizedBox(width: 15),
        Expanded(
          flex: 7,
          child: renderColumnTitle(),
        ),
        Expanded(
          flex: 3,
          child: renderLogo(),
        ),
      ],
    );
  }

  Widget renderBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Text(
            'Para comenzar,',
            style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                height: .5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ingresa el nombre de tu organización',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFFC9B8F9),
                height: .1),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _orgController,
            decoration: InputDecoration(
              hintText: 'Escribe el nombre aquí',
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleArrowTap(BuildContext context) {
    String orgName = _orgController.text.trim();

    if (orgName.isNotEmpty) {
      // Navegar a la pantalla de detalles de la organización
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrganizationDetailScreen(orgName: orgName),
        ),
      );
    } else {
      // mostrar un modal de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Por favor, ingresa el nombre de tu organización'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 15,
            right: 15,
            child: renderTitle(),
          ),
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: renderBody(context),
          ),
          Positioned(
            bottom:
                20, // Ajusta la posición vertical desde abajo según sea necesario
            right:
                20, // Ajusta la posición horizontal desde la derecha según sea necesario
            child: ArrowCircleWidget(
              onTap: () => handleArrowTap(context),
            ),
          ),
        ],
      ),
    );
  }
}
