import 'package:flutter/material.dart';
import 'package:lumotareas/lib/services/preferences_service.dart';

class RedirectSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? backgroundColor;

  const RedirectSwitch({
    required this.value,
    required this.onChanged,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Redirigir a Login',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (bool newValue) async {
          await PreferencesService.setRedirectToLogin(newValue);
          onChanged(newValue);
        },
      ),
      tileColor: backgroundColor,
    );
  }
}
