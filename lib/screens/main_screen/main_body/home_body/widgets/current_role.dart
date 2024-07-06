import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';

class CurrentRole extends StatelessWidget {
  final Usuario user;
  final String organizationId;

  const CurrentRole({
    super.key,
    required this.user,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context) {
    if (user.organizaciones == null ||
        user.organizaciones!.isEmpty ||
        organizationId.isEmpty) {
      return const Contenedor(
        height: 40,
        width: 150,
        color: Colors.red,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Titulo(texto: 'No org', color: Colors.white),
        ],
      );
    }

    bool isOwner = user.isOwnerOfOrganization(organizationId);

    return Contenedor(
      height: 40,
      width: 150,
      color: isOwner ? Colors.green : Colors.blue,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          isOwner ? Icons.star : Icons.person,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 8),
        Titulo(
          texto: isOwner ? 'Propietario' : 'Miembro',
          color: Colors.white,
        ),
      ],
    );
  }
}
