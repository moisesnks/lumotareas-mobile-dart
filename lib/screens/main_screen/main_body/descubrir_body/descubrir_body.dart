import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/post.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/carousel_box_widget.dart';
import './widgets/buscar_organizacion/buscar_organizacion.dart';
import './widgets/publicaciones/publicacion_card.dart';
import './widgets/organizaciones_destacadas/organizacion_card.dart';
import '../../../../logic/descubrir_logic.dart';
import 'package:lumotareas/models/user.dart';

class DescubrirBody extends StatelessWidget {
  final Usuario currentUser;
  const DescubrirBody({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final Future<List<Organization>> organizacionesDestacadas =
        DescubrirLogic.obtenerOrganizacionesDestacadas();
    final List<Post> publicacionesRecientes =
        DescubrirLogic.obtenerPublicacionesRecientes();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Contenedor(
        direction: Axis.vertical,
        children: [
          const BuscarOrganizacion(),
          FutureBuilder<List<Organization>>(
            future: organizacionesDestacadas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No hay organizaciones destacadas.');
              } else {
                return CarouselBox<Organization>(
                  items: snapshot.data!,
                  itemBuilder: (context, index) => OrganizacionCard(
                    currentUser: currentUser,
                    organization: snapshot.data![index],
                  ),
                  labelText: 'Organizaciones Destacadas',
                  height: MediaQuery.of(context).size.height * 0.25,
                );
              }
            },
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
