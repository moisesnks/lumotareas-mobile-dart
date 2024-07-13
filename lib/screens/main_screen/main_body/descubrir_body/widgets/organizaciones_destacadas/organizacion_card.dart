import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/imagen_widget.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/user.dart';

class OrganizacionCard extends StatelessWidget {
  final Organization? organization;
  final Usuario currentUser;

  OrganizacionCard({
    super.key,
    required this.organization,
    required this.currentUser,
  });

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    final String nombre = organization?.nombre ?? '';
    final String owner = organization?.owner.nombre ?? '';
    final String descripcion = organization?.descripcion ?? '';
    final String imageUrl = organization?.imageUrl ?? '';
    final List<String> likes = organization?.likes ?? [];

    return Contenedor(
      height: MediaQuery.of(context).size.height * 0.25,
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
            Contenedor(
              direction: Axis.vertical,
              children: [
                Contenedor(
                  padding: const EdgeInsets.only(left: 10.0),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  height: 100,
                  children: [
                    Contenedor(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Titulo(texto: nombre),
                        Contenedor(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          width: 100,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              onPressed: () {
                                _logger.i(
                                    '${currentUser.uid} ha likeado la organización ${organization?.nombre}');
                              },
                            ),
                            Text(
                              likes.length.toString(),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Titulo(
                      texto: 'por $owner',
                      fontWeight: FontWeight.normal,
                      maxFontSize: 12.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Contenedor(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          direction: Axis.vertical,
          children: [
            Parrafo(
              texto: descripcion,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ],
    );
  }
}
