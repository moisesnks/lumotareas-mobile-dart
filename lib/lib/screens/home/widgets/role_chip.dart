/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class RoleChip extends StatelessWidget {
  final Usuario user;

  const RoleChip({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool hasCurrentOrg = user.currentOrg.isNotEmpty;
    bool hasOrganizations = user.hasOrganization();

    Color chipColor = Colors.grey;
    IconData iconData = Icons.person_outline;
    String role = '';

    if (hasOrganizations) {
      if (hasCurrentOrg) {
        role = user.isOwnerOf(user.currentOrg) ? 'Propietario' : 'Miembro';
        chipColor =
            user.isOwnerOf(user.currentOrg) ? Colors.blue : Colors.green;
        iconData = user.isOwnerOf(user.currentOrg) ? Icons.star : Icons.group;
      } else {
        role = 'Miembro';
        chipColor = Colors.green;
        iconData = Icons.group;
      }
    } else {
      role = 'No Org';
      chipColor = Colors.red; // Color para No Org
      iconData = Icons.error_outline; // Icono para No Org
    }

    return Chip(
      backgroundColor: chipColor,
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          iconData,
          color: chipColor,
          size: 20,
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          role,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
