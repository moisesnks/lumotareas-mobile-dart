/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/widgets/secondary_header.dart';

class MiembroScreen extends StatelessWidget {
  final Usuario usuario;
  final bool isPoppable;

  const MiembroScreen(
      {super.key, required this.usuario, this.isPoppable = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Header(
              title: 'Detalles del Miembro',
              isPoppable: isPoppable,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(usuario.photoURL),
                        radius: 50,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Nombre: ${usuario.nombre}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Correo electrónico: ${usuario.email}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      // Agrega aquí más detalles según sea necesario
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
