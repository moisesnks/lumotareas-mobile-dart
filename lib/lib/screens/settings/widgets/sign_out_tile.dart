/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/lib/providers/auth_provider.dart';
import 'package:logger/logger.dart';

class SignOutTile extends StatelessWidget {
  final Color? backgroundColor;

  const SignOutTile({
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout(context);
        Logger().i('Sesión cerrada');
      },
      trailing: const Icon(Icons.exit_to_app),
      tileColor: backgroundColor,
    );
  }
}
