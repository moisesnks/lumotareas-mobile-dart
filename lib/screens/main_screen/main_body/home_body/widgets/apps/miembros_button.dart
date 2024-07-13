import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/main_body/home_body/screens/usuario_screen.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';
import 'package:lumotareas/widgets/list_items_widget.dart';
import 'package:lumotareas/services/preferences_service.dart';

class MiembrosButton extends StatefulWidget {
  final List<String> miembros;
  final String orgName;

  const MiembrosButton({
    super.key,
    required this.miembros,
    required this.orgName,
  });

  @override
  MiembrosButtonState createState() => MiembrosButtonState();
}

class MiembrosButtonState extends State<MiembrosButton> {
  final UserService _userService = UserService();
  final List<Usuario> _miembros = [];
  bool _isLoading = true;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _cargarMiembros();
  }

  void _cargarMiembros() async {
    for (final id in widget.miembros) {
      Usuario? usuario = await _userService.getUserByUid(id);
      if (usuario != null) {
        if (mounted) {
          setState(() {
            _miembros.add(usuario);
            _isLoading = false;
          });
        }
      } else {
        _logger.e('No se pudo cargar el usuario con el id: $id');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    // Guardar los miembros en las preferencias después de cargarlos
    await PreferenceService.setMiembros(
        _miembros.map((usuario) => usuario.toMap()).toList());
  }

  void _showMemberList(BuildContext context) {
    if (_isLoading) {
      // Mostrar un indicador de carga si los datos aún se están cargando
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cargando proyectos, por favor espere...'),
        ),
      );
    } else if (_miembros.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListItems<Usuario>(
            items: _miembros,
            itemBuilder: (context, usuario) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(usuario.photoURL),
              ),
              title: Text(
                usuario.nombre,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                usuario.isOwnerOfOrganization(widget.orgName)
                    ? 'Dueño'
                    : 'Miembro',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                // Lógica específica según necesites
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsuarioPage(usuario: usuario)),
                );
              },
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay miembros en esta organización.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.people,
      label: 'Miembros',
      count: _miembros.length,
      showCount: true,
      onTap: () => _showMemberList(context),
    );
  }
}
