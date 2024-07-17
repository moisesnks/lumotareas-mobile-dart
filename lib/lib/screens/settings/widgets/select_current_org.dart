/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/models/user/organizaciones.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:lumotareas/lib/widgets/selection_modal.dart';

class SelectCurrentOrg extends StatelessWidget {
  final Color? backgroundColor;

  const SelectCurrentOrg({
    this.backgroundColor,
    super.key,
    required Organizaciones currentOrganization,
  });

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final Usuario? currentUser = userDataProvider.currentUser;

    if (currentUser == null) {
      return const SizedBox();
    }

    final Organizaciones currentOrg = currentUser.organizaciones.firstWhere(
      (org) => org.id == currentUser.currentOrg,
      orElse: () => currentUser.organizaciones.first,
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
      },
      initValue: currentOrg,
      backgroundColor: backgroundColor,
    );
  }
}
