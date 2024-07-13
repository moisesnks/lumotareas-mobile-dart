import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import '../../profile_body/widgets/profile_widget.dart';

class UsuarioPage extends StatelessWidget {
  final Usuario usuario;

  const UsuarioPage({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Contenedor(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              title:
                  'Perfil de ${_capitalizeFirstLetter(usuario.nombre.split(' ').first)}',
              isPoppable: true,
            ),
            Contenedor(
              direction: Axis.vertical,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              children: [
                ProfileWidget(
                  user: usuario,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    return text.toLowerCase().replaceFirstMapped(
        RegExp(r'^\w'), (match) => match.group(0)!.toUpperCase());
  }
}
