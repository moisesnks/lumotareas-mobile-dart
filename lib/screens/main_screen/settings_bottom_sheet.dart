import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'redirect_switch.dart';
import 'package:lumotareas/services/preferences_service.dart';

class SettingsBottomSheet extends StatelessWidget {
  final bool initialRedirectValue;

  const SettingsBottomSheet({super.key, required this.initialRedirectValue});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          RedirectSwitch(initialValue: initialRedirectValue),
        ],
      ),
    );
  }
}
