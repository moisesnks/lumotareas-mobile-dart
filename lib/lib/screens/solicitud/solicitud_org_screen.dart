/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/solicitud.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';

class RequestOrgScreen extends StatelessWidget {
  final Solicitud solicitud;
  final String uid;
  final bool isPoppable;

  const RequestOrgScreen({
    super.key,
    required this.solicitud,
    required this.uid,
    this.isPoppable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Header(
              title: 'Detalles de la Solicitud',
              isPoppable: isPoppable,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Fecha de solicitud: ${solicitud.fecha}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Estado: ${solicitud.estado.toString().split('.').last}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Detalles de la solicitud:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 8.0),
                    ...solicitud.solicitud.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 16.0),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
