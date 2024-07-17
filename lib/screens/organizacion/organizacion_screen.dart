import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/widgets/imagen.dart';

class OrganizacionDetalleScreen extends StatelessWidget {
  final Organizacion organizacion;

  const OrganizacionDetalleScreen({
    super.key,
    required this.organizacion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organizacion.nombre),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: Imagen(imageUrl: organizacion.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              organizacion.descripcion,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
