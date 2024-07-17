/// @nodoc
library;

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<Map<String, dynamic>> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 28, 91),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .asMap()
            .entries
            .map((entry) => _buildNavItem(
                entry.value['icon'], entry.key, entry.value['label']))
            .toList(),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56, // Tamaño del contenedor para el ícono
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index
                          ? const Color(0xFF6C63FF)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      icon,
                      color: currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      size: 30, // Tamaño del ícono
                    ),
                  ),
                  if (currentIndex == index) _buildSelectedIndicator(icon),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 72, // Tamaño del contenedor para el texto
                child: Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    color: currentIndex == index
                        ? const Color(0xFF6C63FF)
                        : Colors.white,
                    fontSize: 12, // Tamaño del texto
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIndicator(IconData icon) {
    return Positioned(
      top: -12,
      right: -10,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF6C63FF),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 34, // Tamaño del ícono dentro del círculo
          ),
        ),
      ),
    );
  }
}
