import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool? _redirectValue;

  @override
  void initState() {
    super.initState();
    _initializeRedirectValue();
  }

  Future<void> _initializeRedirectValue() async {
    bool value = await PreferenceService.getRedirectToLogin();
    setState(() {
      _redirectValue = value;
    });
  }

  Future<void> _handleRedirectSwitchChange(bool value) async {
    setState(() {
      _redirectValue = value;
    });
    await PreferenceService.setRedirectToLogin(value);
  }

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
            if (_redirectValue != null)
              Expanded(
                child: ListView.builder(
                  itemCount: 2, // Dos elementos en la lista
                  itemBuilder: (BuildContext context, int index) {
                    // Color de fondo alternativo
                    Color? backgroundColor = index.isOdd
                        ? const Color(0xFF473774)
                        : const Color(0xFF382D5D);

                    // Selección del título y acción para cada ítem
                    Widget listTile;
                    switch (index) {
                      case 0:
                        listTile = ListTile(
                          title: const Text(
                            'Redirigir a Login',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Switch(
                            value: _redirectValue!,
                            onChanged: _handleRedirectSwitchChange,
                          ),
                          tileColor: backgroundColor, // Aplicar color de fondo
                        );
                        break;
                      case 1:
                        listTile = ListTile(
                          title: const Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () async {
                            await context
                                .read<LoginViewModel>()
                                .signOut(context);
                            await PreferenceService.setCurrentOrganization('');
                          },
                          trailing: const Icon(Icons.exit_to_app),
                          tileColor: backgroundColor, // Aplicar color de fondo
                        );
                        break;
                      default:
                        listTile =
                            Container(); // Por si acaso, aunque no debería llegar aquí
                    }

                    return listTile;
                  },
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}