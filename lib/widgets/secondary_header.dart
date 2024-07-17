// Widget que muestra un encabezado con un título y un logotipo, y un botón opcional para cerrar la página.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Un widget que muestra un encabezado con un título, un logotipo y un botón opcional para cerrar la página.
class Header extends StatelessWidget {
  final VoidCallback? onTap; // Callback cuando se toca el logotipo
  final bool
      isPoppable; // Indica si se debe mostrar un botón para cerrar la página
  final String title; // Título del encabezado

  /// Constructor para crear una instancia de [Header].
  ///
  /// [onTap] es el callback cuando se toca el logotipo.
  /// [isPoppable] indica si se debe mostrar un botón para cerrar la página.
  /// [title] es el título del encabezado.
  const Header({
    super.key,
    this.onTap,
    this.isPoppable = false,
    this.title = 'Lumotareas',
  });

  /// Renderiza el logotipo como un [GestureDetector].
  Widget renderLogo() {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 36,
        height: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF191B5B),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          renderLogo(),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isPoppable)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
