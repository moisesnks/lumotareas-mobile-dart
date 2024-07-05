import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';

class MembershipStatusWidget extends StatelessWidget {
  final Usuario user;
  final String organizationId;

  const MembershipStatusWidget({
    super.key,
    required this.user,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context) {
    if (user.organizaciones == null ||
        user.organizaciones!.isEmpty ||
        organizationId.isEmpty) {
      return const Chip(
        label: Text(
          'No org',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        avatar: Icon(
          Icons.warning,
          color: Colors.white,
          size: 18,
        ),
        backgroundColor: Colors.red,
      );
    }

    bool isOwner = user.isOwnerOfOrganization(organizationId);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          // Versión compacta para pantallas pequeñas
          return Chip(
            label: Text(
              isOwner
                  ? 'Dueño de $organizationId'
                  : 'Miembro de $organizationId',
              style: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            avatar: Icon(
              isOwner ? Icons.star : Icons.person,
              color: Colors.white,
              size: 18, // Tamaño del icono reducido
            ),
            backgroundColor: isOwner ? Colors.blue : Colors.green,
          );
        } else {
          // Versión normal para pantallas grandes
          return Wrap(
            spacing: 8.0,
            children: [
              Chip(
                label: Text(
                  isOwner ? 'Dueño' : 'Miembro',
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                avatar: Icon(
                  isOwner ? Icons.star : Icons.person,
                  color: Colors.white,
                ),
                backgroundColor: isOwner ? Colors.blue : Colors.green,
              ),
            ],
          );
        }
      },
    );
  }
}
