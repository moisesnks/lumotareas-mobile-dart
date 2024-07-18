import 'package:flutter/material.dart';
import 'package:lumotareas/services/preferences_service.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  IndexScreenState createState() => IndexScreenState();
}

class IndexScreenState extends State<IndexScreen> {
  @override
  void initState() {
    super.initState();
    _checkPreferences(context);
  }

  Future<void> _checkPreferences(BuildContext context) async {
    bool redirectToLogin = await PreferencesService.getRedirectToLogin();
    if (redirectToLogin && context.mounted) {
      // Redirigir a /login
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Redirigir a /welcome
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/register');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
