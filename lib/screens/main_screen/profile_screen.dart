import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await context.read<LoginViewModel>().signOut(context);
                // borra la organización actual de la preferencia
                await PreferenceService.setCurrentOrganization('');
              },
              trailing: const Icon(Icons.exit_to_app),
            ),
            // Aquí puedes agregar más widgets para mostrar información del usuario
            Text('Nombre: ${currentUser.nombre}'),
            Text('Email: ${currentUser.email}'),
            Text('Fecha de nacimiento: ${currentUser.birthdate}'),
          ],
        ),
      ),
    );
  }
}
