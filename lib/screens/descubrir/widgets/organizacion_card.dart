import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/screens/organizacion/organizacion_screen.dart';
import 'package:lumotareas/widgets/imagen.dart';
import 'package:provider/provider.dart';

import 'like_button.dart';

class OrganizacionCard extends StatefulWidget {
  final Organizacion organizacion;

  const OrganizacionCard({
    super.key,
    required this.organizacion,
  });

  @override
  OrganizacionCardState createState() => OrganizacionCardState();
}

class OrganizacionCardState extends State<OrganizacionCard> {
  int likesCount = 0; // Estado local para contar los likes

  @override
  void initState() {
    super.initState();
    likesCount = widget.organizacion.likes.length;
  }

  void handleLike(bool isLiked, Usuario currentUser) {
    setState(() {
      if (isLiked) {
        likesCount++;
        widget.organizacion.likes.add(currentUser.uid);
      } else {
        likesCount--;
        widget.organizacion.likes.remove(currentUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, provider, child) {
        final Usuario? currentUser = provider.currentUser;
        if (currentUser == null) {
          return const SizedBox.shrink();
        }
        final String nombre = widget.organizacion.nombre;
        final Usuario owner = widget.organizacion.owner;
        final String descripcion = widget.organizacion.descripcion;
        final String imageUrl = widget.organizacion.imageUrl;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrganizacionDetalleScreen(
                  organizacion: widget.organizacion,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Imagen(imageUrl: imageUrl),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    nombre,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      LikeButton(
                                        organization: widget.organizacion,
                                        onCallback: (isLiked) {
                                          handleLike(isLiked, currentUser);
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '$likesCount',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'por ${owner.nombre}',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: Text(
                      descripcion,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
