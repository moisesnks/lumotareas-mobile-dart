import 'package:flutter/material.dart';

class DetalleOrgScreen extends StatelessWidget {
  final String orgName;

  const DetalleOrgScreen({super.key, required this.orgName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de $orgName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Detalles de la organización $orgName',
              style: const TextStyle(fontSize: 24),
            ),
            // Aquí puedes agregar más widgets para mostrar detalles adicionales
          ],
        ),
      ),
    );
  }
}
