import 'package:flutter/material.dart';
import 'package:lumotareas/providers/organization_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/models/user/organizaciones.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/widgets/selection_modal.dart';

class SelectCurrentOrg extends StatelessWidget {
  final Color? backgroundColor;

  const SelectCurrentOrg({
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final organizationDataProvider =
        Provider.of<OrganizationDataProvider>(context);
    final Usuario? currentUser = userDataProvider.currentUser;

    if (currentUser == null) {
      return const SizedBox();
    }

    // Verificar si el usuario tiene organizaciones
    if (currentUser.organizaciones.isEmpty) {
      return Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'No estás en ninguna organización actualmente',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    final Organizaciones currentOrg = currentUser.organizaciones.firstWhere(
      (org) => org.id == currentUser.currentOrg,
      orElse: () => Organizaciones.empty(),
    );

    return SelectionModal<Organizaciones>(
      listTileTitle: 'Organización actual',
      modalTitle: 'Seleccione su organización',
      alertTitle:
          '¿Está seguro de cambiar su organización actual ${currentOrg.nombre} a ',
      items: currentUser.organizaciones,
      displayField: (org) => org.nombre,
      subtitleField: (org) => org.id,
      onSelected: (selectedOrg) async {
        final updatedUser = Usuario(
          uid: currentUser.uid,
          nombre: currentUser.nombre,
          email: currentUser.email,
          birthdate: currentUser.birthdate,
          photoURL: currentUser.photoURL,
          currentOrg: selectedOrg.id,
          organizaciones: currentUser.organizaciones,
          solicitudes: currentUser.solicitudes,
        );

        await userDataProvider.updateUserData(context, updatedUser);
        if (context.mounted) {
          await organizationDataProvider
              .fetchOrganization(context, selectedOrg.id, forceFetch: true);
        }
      },
      initValue: currentOrg,
      backgroundColor: backgroundColor,
    );
  }
}
