import 'package:flutter/material.dart';
import 'fecha_widget.dart';

class OrgFormulario extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  const OrgFormulario({
    super.key,
    required this.emailController,
    required this.fullNameController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Ingresa tu correo electrónico',
              labelStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
              filled: true,
              fillColor: const Color(0xFF191B5B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onChanged: (value) {
              // Validación de correo electrónico
              bool isValid =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
              if (!isValid) {}
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: fullNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Tu nombre completo',
              labelStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
              filled: true,
              fillColor: const Color(0xFF191B5B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          const SizedBox(height: 10),
          FechaWidget(
            dayController: dayController,
            monthController: monthController,
            yearController: yearController,
          ),
        ],
      ),
    );
  }
}
