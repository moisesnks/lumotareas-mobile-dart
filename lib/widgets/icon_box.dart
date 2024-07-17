// Widget que muestra un icono con una etiqueta y un contador opcional.
library;

import 'package:flutter/material.dart';

/// Un widget que muestra un ícono con una etiqueta y un contador opcional.
class IconBox extends StatelessWidget {
  final IconData icon; // Icono a mostrar
  final String label; // Etiqueta a mostrar debajo del icono
  final int? count; // Contador opcional a mostrar
  final bool showCount; // Indica si se debe mostrar el contador
  final VoidCallback onTap; // Función a ejecutar cuando se presiona el widget

  /// Constructor para crear una instancia de [IconBox].
  ///
  /// [icon] es el icono a mostrar.
  /// [label] es la etiqueta a mostrar debajo del icono.
  /// [count] es el contador opcional a mostrar.
  /// [showCount] indica si se debe mostrar el contador.
  /// [onTap] es la función a ejecutar cuando se presiona el widget.
  const IconBox({
    super.key,
    required this.icon,
    required this.label,
    this.count,
    this.showCount = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: count != null && count! > 0
                  ? const Color(0xFF6C63FF)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: count != null && count! > 0
                      ? Colors.white
                      : Colors.black45,
                  size: 50,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (showCount && count != null && count! > 0)
            Positioned(
              top: -10,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
