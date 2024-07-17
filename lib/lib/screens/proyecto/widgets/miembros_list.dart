/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/firestore/proyecto.dart';
import 'package:lumotareas/lib/screens/miembro/miembro_screen.dart';
import 'package:lumotareas/lib/utils/constants.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class MiembrosList extends StatefulWidget {
  final List<Usuario> usuariosAsignados;
  final List<Usuario> miembrosOrganizacion;
  final String userId;
  final ProyectoFirestore proyecto;

  const MiembrosList({
    super.key,
    required this.miembrosOrganizacion,
    required this.userId,
    required this.proyecto,
    required this.usuariosAsignados,
  });

  @override
  MiembrosListState createState() => MiembrosListState();
}

class MiembrosListState extends State<MiembrosList> {
  bool _isListVisible = false;

  Widget _buildButton(Icon icon, Function() onTap, Color? backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildActionButtons() {
    if (widget.userId == widget.proyecto.createdBy) {
      return Row(
        children: [
          _buildButton(
            const Icon(Icons.add, color: Colors.white),
            () {
              Logger().i('Agregar miembro');
            },
            Colors.green[600],
          ),
          const SizedBox(width: 8),
          _buildButton(
            const Icon(Icons.remove, color: Colors.white),
            () {
              Logger().i('Eliminar miembro');
            },
            Colors.red[600],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
      Logger().i(_isListVisible
          ? 'Mostrar lista de miembros'
          : 'Ocultar lista de miembros');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StyledListTile(
        index: 1,
        leading: const Icon(Icons.people),
        title: const Text('Miembros'),
        subtitle: Text(
          '${widget.usuariosAsignados.length} ${widget.usuariosAsignados.length == 1 ? 'miembro' : 'miembros'}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButtons(),
            const SizedBox(width: 8),
            _buildButton(
              Icon(_isListVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white),
              _toggleListVisibility,
              secondaryColor,
            ),
          ],
        ),
        onTap: _toggleListVisibility,
      ),
      if (_isListVisible)
        ...widget.usuariosAsignados.map((usuario) {
          int index = widget.usuariosAsignados.indexOf(usuario);
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
            },
          );
        }),
    ]);
  }
}
