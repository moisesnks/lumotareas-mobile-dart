import 'package:flutter/material.dart';
import 'package:lumotareas/screens/descubrir/widgets/buscar_organizacion.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/providers/descubrir_data_provider.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/widgets/carousel_box.dart';

import 'widgets/organizacion_card.dart';

class DescubrirScreen extends StatefulWidget {
  const DescubrirScreen({super.key});

  @override
  DescubrirScreenState createState() => DescubrirScreenState();
}

class DescubrirScreenState extends State<DescubrirScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<DescubrirDataProvider>(context, listen: false);
      provider.obtenerOrganizacionesDestacadas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<DescubrirDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.organizacionesDestacadas.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () =>
                provider.obtenerOrganizacionesDestacadas(forceReload: true),
            child: provider.organizacionesDestacadas.isEmpty
                ? ListView(
                    children: const [
                      Center(child: Text('No hay organizaciones')),
                    ],
                  )
                : ListView(
                    children: [
                      const BuscarOrganizacion(),
                      const SizedBox(height: 16.0),
                      CarouselBox<Organizacion>(
                        items: provider.organizacionesDestacadas,
                        itemBuilder: (context, index) => OrganizacionCard(
                          organizacion:
                              provider.organizacionesDestacadas[index],
                        ),
                        labelText: 'Organizaciones destacadas',
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
