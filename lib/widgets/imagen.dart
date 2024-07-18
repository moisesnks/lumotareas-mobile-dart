import 'package:flutter/material.dart';

class Imagen extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String placeholder;
  final BoxFit fit;

  const Imagen({
    super.key,
    required this.imageUrl,
    this.width = 300,
    this.height = 200,
    this.borderRadius = 10,
    this.placeholder = 'assets/images/placeholder_image.jpg',
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      // Si la URL de la imagen está vacía, muestra la imagen de placeholder
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          placeholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: FadeInImage.assetNetwork(
        placeholder: placeholder,
        image: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          placeholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
