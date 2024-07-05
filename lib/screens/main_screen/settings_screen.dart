import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'redirect_switch.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header.dart';

class SettingsScreen extends StatelessWidget {
  final bool initialRedirectValue;

  const SettingsScreen({Key? key, required this.initialRedirectValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Header(
              title: 'Configuración',
              isPoppable: true,
            ),
            RedirectSwitch(initialValue: initialRedirectValue),
            Expanded(
              child: ListView.builder(
                itemCount: 1, // Añade más elementos según sea necesario
                itemBuilder: (BuildContext context, int index) {
                  // Color de fondo alternativo
                  Color? backgroundColor =
                      index.isOdd ? Color(0xFFC9B8F9) : Color(0xFFA193C7);

                  // Ejemplo de ListTile con título y función onTap
                  return ListTile(
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      await context.read<LoginViewModel>().signOut(context);
                      await PreferenceService.setCurrentOrganization('');
                    },
                    trailing: const Icon(Icons.exit_to_app),
                    tileColor: backgroundColor, // Aplicar color de fondo
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
