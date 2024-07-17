/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/widgets/icon_box.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/miembro/miembro_screen.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class MembersButton extends StatelessWidget {
  final List<Usuario> miembros;

  const MembersButton({super.key, required this.miembros});

  void showMembersList(BuildContext context) {
    if (miembros.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay miembros en esta organización.'),
        ),
      );
    }
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(155, 56, 45, 93),
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: miembros.length,
          itemBuilder: (BuildContext context, int index) {
            final Usuario miembro = miembros[index];
            return StyledListTile(
              index: index,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(miembro.photoURL),
              ),
              title: Text(miembro.nombre),
              subtitle: Text(miembro.isOwnerOf(miembro.currentOrg)
                  ? 'Propietario'
                  : 'Miembro'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MiembroScreen(usuario: miembro),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.people,
      label: 'Miembros',
      count: miembros.length,
      showCount: true,
      onTap: () => showMembersList(context),
    );
  }
}
