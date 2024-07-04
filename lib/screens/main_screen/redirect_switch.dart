import 'package:flutter/material.dart';
import 'package:lumotareas/services/preferences_service.dart';

class RedirectSwitch extends StatefulWidget {
  const RedirectSwitch({super.key, required this.initialValue});

  final bool initialValue;

  @override
  RedirectSwitchState createState() => RedirectSwitchState();
}

class RedirectSwitchState extends State<RedirectSwitch> {
  late bool redirectToLogin;

  @override
  void initState() {
    super.initState();
    redirectToLogin = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Redirigir a Login'),
      value: redirectToLogin,
      onChanged: (value) async {
        setState(() {
          redirectToLogin = value;
        });
        await PreferenceService.setRedirectToLogin(value);
      },
    );
  }
}
