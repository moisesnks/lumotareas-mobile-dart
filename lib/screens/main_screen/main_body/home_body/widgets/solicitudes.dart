import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';

class Solicitudes extends StatelessWidget {
  final int solicitudes;
  final VoidCallback onTap;
  final bool small;

  const Solicitudes({
    super.key,
    required this.solicitudes,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Contenedor(
      color: const Color(0xFF6C63FF),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      onTap: onTap,
      children: small
          ? [
              const Icon(
                Icons.email,
                color: Colors.white,
                size: 18,
              ),
              Parrafo(
                texto: solicitudes.toString(),
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ]
          : [
              Parrafo(
                texto: solicitudes == 0
                    ? 'No tienes solicitudes pendientes'
                    : solicitudes == 1
                        ? 'Tienes 1 solicitud pendiente'
                        : 'Tienes $solicitudes solicitudes pendientes',
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
    );
  }
}
