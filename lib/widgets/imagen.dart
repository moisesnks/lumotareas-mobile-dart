import 'package:flutter/material.dart';

class Imagen extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const Imagen({
    super.key,
    required this.imageUrl,
    this.width = 300,
    this.height = 200,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset('assets/images/placeholder_image.jpg');
        },
      ),
    );
  }
}
