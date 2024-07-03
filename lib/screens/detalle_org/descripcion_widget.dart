import 'package:flutter/material.dart';

class DescriptionQuote extends StatelessWidget {
  final String descripcion;

  const DescriptionQuote({super.key, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                descripcion,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF6466A8),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            const Positioned(
              // Mover el segundo quote a la esquina inferior derecha
              bottom: 0,
              right: 0,
              child: Text(
                '”',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
            const Positioned(
              // Mantener el primer quote en la esquina superior izquierda
              top: 0,
              left: 0,
              child: Text(
                '“',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
              child: Text(
                descripcion,
                maxLines: 5, // Máximo de 5 líneas visibles
                overflow: TextOverflow
                    .ellipsis, // Puntos suspensivos al final del texto
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
