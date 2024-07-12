import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';

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
        width: MediaQuery.of(context).size.width,
        height: 150,
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF6466A8),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 0,
              left: 0,
              child: Text(
                '\u201C',
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
                child: Parrafo(
                  texto: descripcion,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  maxLines: 5,
                )),
            const Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                '\u201D',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
