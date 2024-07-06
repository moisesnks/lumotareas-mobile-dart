import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/post.dart';
import 'package:lumotareas/widgets/box_label_widget.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';

import './logic.dart';
import './widgets/buscar_organizacion/buscar_organizacion.dart';
import './widgets/publicaciones/publicacion_card.dart';
import './widgets/organizaciones_destacadas/organizacion_card.dart';

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
          BuscarOrganizacion(),
          BoxLabel(
            padding: const EdgeInsets.only(top: 16.0),
            labelText: 'Organizaciones Destacadas',
            borderColor: const Color.fromARGB(255, 100, 102, 168),
            labelBackgroundColor: const Color.fromARGB(255, 7, 8, 29),
            child: CarouselSlider.builder(
              itemCount: organizacionesDestacadas.length,
              options: CarouselOptions(
                height: 125,
                viewportFraction: 0.9,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return OrganizacionCard(
                  organization: organizacionesDestacadas[index],
                );
              },
            ),
          ),
          BoxLabel(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            labelText: 'Publicaciones Recientes',
            borderColor: const Color.fromARGB(255, 100, 102, 168),
            labelBackgroundColor: const Color.fromARGB(255, 7, 8, 29),
            child: CarouselSlider.builder(
              itemCount: publicacionesRecientes.length,
              options: CarouselOptions(
                height: 360,
                viewportFraction: 0.9,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return PublicacionCard(
                  post: publicacionesRecientes[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
