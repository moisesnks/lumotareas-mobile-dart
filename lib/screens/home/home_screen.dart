import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/providers/organization_data_provider.dart';

import 'widgets/apps_menu.dart';
import 'widgets/role_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final orgDataProvider =
        Provider.of<OrganizationDataProvider>(context, listen: false);
    final Usuario? currentUser = userDataProvider.currentUser;

    if (currentUser != null) {
      // Fetch user data
      await userDataProvider.fetchUserData(context);
      // Fetch organization data if user has a current organization
      if (currentUser.currentOrg.isNotEmpty) {
        await orgDataProvider.fetchOrganization(
          // ignore: use_build_context_synchronously
          context,
          currentUser.currentOrg,
          forceFetch: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final orgDataProvider =
          Provider.of<OrganizationDataProvider>(context, listen: false);
      final Usuario? currentUser = userDataProvider.currentUser;

      if (currentUser != null && currentUser.currentOrg.isNotEmpty) {
        orgDataProvider.fetchOrganization(context, currentUser.currentOrg);
      }
    });

    return Consumer2<UserDataProvider, OrganizationDataProvider>(
      builder: (context, userDataProvider, orgDataProvider, child) {
        final Usuario? currentUser = userDataProvider.currentUser;
        final Organizacion? currentOrg = orgDataProvider.organization;

        if (currentUser == null) {
          return const Center(
            child: Text('No hay usuario logueado'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
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
                AppsMenu(currentUser: currentUser, currentOrg: currentOrg),
              ],
            ),
          ),
        );
      },
    );
  }
}
