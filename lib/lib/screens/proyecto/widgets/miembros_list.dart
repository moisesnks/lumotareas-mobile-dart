import 'package:flutter/material.dart';
import 'package:lumotareas/lib/screens/miembro/miembro_screen.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/utils/constants.dart';

class MiembrosList extends StatelessWidget {
  final List<Usuario> usuariosAsignados;

  const MiembrosList({
    super.key,
    required this.usuariosAsignados,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: secondaryColor,
        child: const Column(
          children: [
            Divider(
              color: primaryColor,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text('Miembros',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Divider(
              color: primaryColor,
              thickness: 1,
            ),
          ],
        ),
      ),
      ...usuariosAsignados.map((usuario) {
        int index = usuariosAsignados.indexOf(usuario);
        return StyledListTile(
            index: index,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(usuario.photoURL),
            ),
            title: Text(usuario.nombre),
            subtitle: Text(usuario.email),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MiembroScreen(usuario: usuario),
                ),
              );
            });
      }),
    ]);
  }
}
