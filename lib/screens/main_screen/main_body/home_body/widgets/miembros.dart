import 'package:flutter/material.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';

class Miembros extends StatefulWidget {
  final List<String> miembros;

  const Miembros({
    super.key,
    required this.miembros,
  });

  @override
  MiembrosState createState() => MiembrosState();
}

class MiembrosState extends State<Miembros> {
  final UserService _userService = UserService();
  List<String> _nombres = [];

  @override
  void initState() {
    super.initState();
    _cargarNombres();
  }

  Future<void> _cargarNombres() async {
    List<String> nombres = await obtenerNombres();
    if (mounted) {
      setState(() {
        _nombres = nombres;
      });
    }
  }

  Future<List<String>> obtenerNombres() async {
    List<String> nombres = [];
    for (String uid in widget.miembros) {
      Usuario? user = await _userService.getUserByUid(uid);
      if (user != null) {
        nombres.add(user.nombre);
      }
    }
    return nombres;
  }

  void _showMemberList(BuildContext context) {
    if (widget.miembros.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: const Color(0xFF111111),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Lista de miembros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _nombres.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          _nombres[index],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.group,
      label: 'Miembros',
      count: widget.miembros.length,
      showCount: true,
      onTap: () => _showMemberList(context),
    );
  }
}
