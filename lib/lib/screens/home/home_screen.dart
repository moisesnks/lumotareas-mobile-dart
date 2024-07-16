import 'package:flutter/material.dart';
import 'package:lumotareas/lib/screens/home/widgets/apps_menu.dart';
import 'package:provider/provider.dart';

import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';

import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';

import 'widgets/role_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orgDataProvider = Provider.of<OrganizationDataProvider>(context);

    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        final Usuario? currentUser = userDataProvider.currentUser;

        if (currentUser != null && currentUser.currentOrg.isNotEmpty) {
          return FutureBuilder(
            future: orgDataProvider.fetchOrganization(
                context, currentUser.currentOrg),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  orgDataProvider.organization == null) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text('Cargando organización...'),
                    ],
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  // Manejar errores si falla la obtención de datos
                  return const Center(
                    child: Text('Error al cargar la organización'),
                  );
                } else {
                  final Organizacion currentOrg = orgDataProvider.organization!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bienvenido, ${currentUser.nombre.split(' ')[0]}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lexend',
                              ),
                            ),
                            RoleChip(user: currentUser),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        AppsMenu(
                            currentUser: currentUser, currentOrg: currentOrg)
                      ],
                    ),
                  );
                }
              }
            },
          );
        } else {
          return const Center(
            child: Text('No hay usuario logueado'),
          );
        }
      },
    );
  }
}
