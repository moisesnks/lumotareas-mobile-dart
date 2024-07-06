// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/imagen_widget.dart';
import 'package:lumotareas/models/post.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';

class PublicacionCard extends StatelessWidget {
  final Post? post;

  const PublicacionCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final String nombre = post?.nombre ?? '';
    final String titulo = post?.titulo ?? '';
    final String contenido = post?.contenido ?? '';
    final String fecha = post?.fecha ?? '';
    final String imageUrl = post?.imageUrl ?? '';
    final String organizationImageUrl = post?.organizationImageUrl ?? '';
    final int comentarios = post?.comentarios ?? 0;
    final int likes = post?.likes ?? 0;

    return Contenedor(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Contenedor(
            direction: Axis.vertical,
            children: [
              Imagen(
                width: MediaQuery.of(context).size.width,
                height: 150,
                imageUrl: imageUrl,
              ),
              const SizedBox(height: 10.0),
              Contenedor(
                  padding: const EdgeInsets.all(10.0),
                  direction: Axis.vertical,
                  children: [
                    Titulo(
                      texto: titulo,
                    ),
                    const SizedBox(height: 10.0),
                    Titulo(
                      texto: contenido,
                    )
                  ]),
              Contenedor(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                padding: const EdgeInsets.all(10.0),
                direction: Axis.horizontal,
                children: [
                  Imagen(
                    width: 50,
                    height: 50,
                    imageUrl: organizationImageUrl,
                  ),
                  const SizedBox(width: 10.0),
                  Contenedor(
                    direction: Axis.vertical,
                    children: [
                      Titulo(
                        texto: nombre,
                      ),
                      const SizedBox(height: 5.0),
                      Parrafo(
                        texto: fecha,
                      )
                    ],
                  ),
                  Expanded(
                    child: Contenedor(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      padding: const EdgeInsets.only(left: 10.0),
                      direction: Axis.horizontal,
                      children: [
                        Contenedor(
                          direction: Axis.horizontal,
                          children: [
                            const Icon(Icons.comment),
                            const SizedBox(width: 5.0),
                            Text(comentarios.toString()),
                          ],
                        ),
                        Contenedor(
                          direction: Axis.horizontal,
                          children: [
                            const Icon(Icons.favorite),
                            const SizedBox(width: 5.0),
                            Text(likes.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
