import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/solicitudes.dart';

class RequestUserScreen extends StatelessWidget {
  final Solicitudes solicitud;

  const RequestUserScreen({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Solicitud: ${solicitud.orgName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Solicitud ID: ${solicitud.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Organización: ${solicitud.orgName}',
              style: const TextStyle(fontSize: 16),
            ),
            // Agrega más detalles según sea necesario
          ],
        ),
      ),
    );
  }
}
