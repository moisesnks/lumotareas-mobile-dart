import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/imagen_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:lumotareas/models/user.dart';
import 'widgets/like_button_widget.dart';

class OrganizacionCard extends StatefulWidget {
  final Organization? organization;
  final Usuario currentUser;

  const OrganizacionCard({
    super.key,
    required this.organization,
    required this.currentUser,
  });

  @override
  OrganizacionCardState createState() => OrganizacionCardState();
}

class OrganizacionCardState extends State<OrganizacionCard> {
  int likesCount = 0; // Estado local para contar los likes

  @override
  void initState() {
    super.initState();
    likesCount = widget.organization?.likes.length ?? 0;
  }

  void handleLike(bool isLiked) {
    setState(() {
      if (isLiked) {
        likesCount++;
        widget.organization?.likes.add(widget.currentUser.uid);
      } else {
        likesCount--;
        widget.organization?.likes.remove(widget.currentUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String nombre = widget.organization?.nombre ?? '';
    final String owner = widget.organization?.owner.nombre ?? '';
    final String descripcion = widget.organization?.descripcion ?? '';
    final String imageUrl = widget.organization?.imageUrl ?? '';

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
                            LikeButton(
                              organization: widget.organization,
                              onCallback: (isLiked) {
                                handleLike(isLiked);
                              },
                            ),
                            Text(
                              '$likesCount',
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
