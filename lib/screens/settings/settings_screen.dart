/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/user/organizaciones.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/widgets/secondary_header.dart';
import 'widgets/redirect_switch.dart';
import 'widgets/sign_out_tile.dart';
import 'widgets/select_current_org.dart';

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
    _initializeValues();
  }

  Future<void> _initializeValues() async {
    bool redirectValue = await PreferencesService.getRedirectToLogin();
    setState(() {
      _redirectValue = redirectValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserDataProvider>(
          builder: (context, userDataProvider, child) {
            final Usuario? currentUser = userDataProvider.currentUser;
            if (currentUser == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final Organizaciones currentOrganization =
                currentUser.organizaciones.firstWhere(
              (org) => org.id == currentUser.currentOrg,
              orElse: () => Organizaciones.empty(),
            );

            return _buildSettingsScreen(
              redirectValue: _redirectValue,
              currentOrganization: currentOrganization,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsScreen({
    required bool? redirectValue,
    required Organizaciones currentOrganization,
  }) {
    return Column(
      children: <Widget>[
        const Header(
          title: 'Configuración',
          isPoppable: true,
        ),
        if (redirectValue != null)
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                Color? backgroundColor = index.isOdd
                    ? const Color(0xFF473774)
                    : const Color(0xFF382D5D);

                switch (index) {
                  case 0:
                    return SelectCurrentOrg(
                      backgroundColor: backgroundColor,
                    );
                  case 1:
                    return RedirectSwitch(
                      value: redirectValue,
                      onChanged: (value) => setState(() {
                        _redirectValue = value;
                      }),
                      backgroundColor: backgroundColor,
                    );
                  case 2:
                    return SignOutTile(
                      backgroundColor: backgroundColor,
                    );
                  default:
                    return Container();
                }
              },
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
