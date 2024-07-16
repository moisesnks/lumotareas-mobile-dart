import 'package:flutter/material.dart';
import 'package:lumotareas/lib/screens/home/widgets/apps_menu.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import 'package:lumotareas/lib/screens/settings/settings_screen.dart';

import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';

import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';

import 'widgets/role_chip.dart';

import 'package:lumotareas/lib/widgets/primary_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    final orgDataProvider = Provider.of<OrganizationDataProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<UserDataProvider>(
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
                      final Organizacion currentOrg =
                          orgDataProvider.organization!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Header(
                                title: currentUser.currentOrg,
                                onLogoTap: () {
                                  _logger.i('Logo tapped!');
                                },
                                suffixIcon: const Icon(Icons.settings),
                                onSuffixTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        currentUser: currentUser,
                                        currentOrg: currentOrg)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
        ),
      ),
    );
  }
}
