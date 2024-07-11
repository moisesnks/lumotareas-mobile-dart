import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import './widgets/history_list.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser;

    return Scaffold(
      body: SafeArea(
        child: currentUser == null
            ? const SizedBox.shrink() // SizedBox vacío si currentUser es null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text('Cerrar sesión'),
                    onTap: () async {
                      await context.read<LoginViewModel>().signOut(context);
                      // Borra la organización actual de la preferencia
                      await PreferenceService.setCurrentOrganization('');
                    },
                    trailing: const Icon(Icons.exit_to_app),
                  ),
                  // Aquí puedes agregar más widgets para mostrar información del usuario
                  Text('Nombre: ${currentUser.nombre}'),
                  Text('Email: ${currentUser.email}'),
                  Text('Fecha de nacimiento: ${currentUser.birthdate}'),
                  const Divider(),
                  const HistoryList(),
                ],
              ),
      ),
    );
  }
}
