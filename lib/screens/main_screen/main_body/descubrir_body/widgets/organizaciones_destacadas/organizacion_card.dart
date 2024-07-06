import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/imagen_widget.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';

class OrganizacionCard extends StatelessWidget {
  final Organization? organization;

  const OrganizacionCard({
    super.key,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    final String nombre = organization?.nombre ?? '';
    final String owner = organization?.owner.nombre ?? '';
    final String descripcion = organization?.descripcion ?? '';
    final String imageUrl = organization?.imageUrl ?? '';

    return Contenedor(
      direction: Axis.vertical,
      children: [
        Contenedor(
          direction: Axis.horizontal,
          children: [
            Contenedor(
              children: [
                Imagen(
                  imageUrl: imageUrl,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            Expanded(
                child: Contenedor(
              padding: const EdgeInsets.only(left: 10.0),
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.vertical,
              height: 100,
              children: [
                Titulo(texto: nombre),
                Titulo(
                  texto: 'por $owner',
                  fontWeight: FontWeight.normal,
                  maxFontSize: 12.0,
                ),
                Text(
                  descripcion,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ))
          ],
        ),
      ],
    );
  }
}
