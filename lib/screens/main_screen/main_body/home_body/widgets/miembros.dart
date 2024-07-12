import 'package:flutter/material.dart';

class Miembros extends StatelessWidget {
  final int miembros;
  final VoidCallback onTap;

  const Miembros({
    super.key,
    required this.miembros,
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: miembros > 0 ? const Color(0xFF6C63FF) : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.group,
              color: miembros > 0 ? Colors.white : Colors.black45,
              size: 30,
            ),
          ),
          if (miembros > 0)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$miembros',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
