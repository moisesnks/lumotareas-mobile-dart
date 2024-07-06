import 'package:flutter/material.dart';

/// Widget personalizado que representa un contenedor con propiedades de diseño flexibles.
class Contenedor extends StatelessWidget {
  final Color? color; // Cambiado a Color nullable para admitir null
  final List<Widget> children;
  final BorderRadius borderRadius;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Axis direction; // Dirección del contenido del Flex
  final VoidCallback? onTap; // Función opcional para manejar el tap
  final Color borderColor; // Color del borde del contenedor
  final EdgeInsets padding; // Padding del contenedor
  final double? width; // Ancho del contenedor, nullable para ajuste automático
  final double? height; // Alto del contenedor, nullable para ajuste automático

  /// Constructor del Contenedor.
  ///
  /// [color]: Color de fondo del contenedor. Debe ser subtipo de Color, como MaterialColor o ColorSwatch.
  /// [children]: Lista de widgets hijos dentro del contenedor.
  /// [borderRadius]: Radio de borde del contenedor (por defecto: 8).
  /// [mainAxisAlignment]: Alineación principal del contenido (por defecto: MainAxisAlignment.start).
  /// [crossAxisAlignment]: Alineación cruzada del contenido (por defecto: CrossAxisAlignment.center).
  /// [mainAxisSize]: Tamaño principal del contenedor (por defecto: MainAxisSize.max).
  /// [direction]: Dirección del contenido dentro del contenedor (por defecto: Axis.horizontal).
  /// [onTap]: Función opcional que se ejecuta al tocar el contenedor.
  const Contenedor({
    super.key,
    this.color,
    required this.children,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.direction = Axis.horizontal,
    this.onTap,
    this.borderColor = Colors.transparent,
    this.padding = const EdgeInsets.all(0.0),
    this.width, // Nullable para ajuste automático
    this.height, // Nullable para ajuste automático
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Asigna onTap al GestureDetector si está definido.
      child: Container(
        constraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: width ??
              double
                  .infinity, // Ajusta según el ancho especificado o ajuste automático
          maxHeight: height ??
              double
                  .infinity, // Ajusta según el alto especificado o ajuste automático
        ),
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          border: Border.all(
            color: borderColor,
          ),
        ),
        clipBehavior: Clip.none,
        child: Flex(
          clipBehavior: Clip.none,
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ),
      ),
    );
  }
}
