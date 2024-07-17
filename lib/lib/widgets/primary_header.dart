// Widget que muestra un encabezado con un título, un logotipo y un ícono opcional.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Un widget que muestra un encabezado con un título, un logotipo y un ícono opcional.
class Header extends StatelessWidget {
  final String title; // Título del encabezado
  final VoidCallback? onLogoTap; // Callback cuando se toca el logotipo
  final VoidCallback? onSuffixTap; // Callback cuando se toca el ícono opcional
  final Widget? suffixIcon; // Ícono opcional en el encabezado

  /// Constructor para crear una instancia de [Header].
  ///
  /// [title] es el título del encabezado.
  /// [onLogoTap] es el callback cuando se toca el logotipo.
  /// [onSuffixTap] es el callback cuando se toca el ícono opcional.
  /// [suffixIcon] es el ícono opcional en el encabezado.
  const Header({
    super.key,
    required this.title,
    this.onLogoTap,
    this.onSuffixTap,
    this.suffixIcon,
  });

  /// Renderiza el logotipo como un [GestureDetector].
  Widget renderLogo() {
    return GestureDetector(
      onTap: onLogoTap,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              renderLogo(),
              const SizedBox(height: 4),
              const Text(
                'Lumotareas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (suffixIcon != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: GestureDetector(
                onTap: onSuffixTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Alinear el icono a la derecha dentro del padding
                  children: [
                    if (suffixIcon != null) suffixIcon!,
                    if (suffixIcon == null)
                      const SizedBox(
                        width: 36,
                        height: 36,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
