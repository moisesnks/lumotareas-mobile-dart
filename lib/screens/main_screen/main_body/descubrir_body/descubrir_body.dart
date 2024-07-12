import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/post.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/carousel_box_widget.dart';
import './widgets/buscar_organizacion/buscar_organizacion.dart';
import './widgets/publicaciones/publicacion_card.dart';
import './widgets/organizaciones_destacadas/organizacion_card.dart';
import './logic.dart';

class DescubrirBody extends StatelessWidget {
  const DescubrirBody({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Organization> organizacionesDestacadas =
        DescubrirLogic.obtenerOrganizacionesDestacadas();
    final List<Post> publicacionesRecientes =
        DescubrirLogic.obtenerPublicacionesRecientes();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Contenedor(
        direction: Axis.vertical,
        children: [
          const BuscarOrganizacion(),
          CarouselBox<Organization>(
            items: organizacionesDestacadas,
            itemBuilder: (context, index) => OrganizacionCard(
              organization: organizacionesDestacadas[index],
            ),
            labelText: 'Organizaciones Destacadas',
            height: 125,
          ),
          CarouselBox<Post>(
            items: publicacionesRecientes,
            itemBuilder: (context, index) => PublicacionCard(
              post: publicacionesRecientes[index],
            ),
            labelText: 'Publicaciones Recientes',
            height: 370,
            autoPlayInterval: const Duration(seconds: 15),
          ),
        ],
      ),
    );
  }
}
