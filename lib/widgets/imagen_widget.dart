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
          // If image network fails, try loading from assets
          return Image.asset(
            'assets/placeholder_image.png', // Placeholder asset image path
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              // If both network and asset loading fail, show a container with an icon
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
