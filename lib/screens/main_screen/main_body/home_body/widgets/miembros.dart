import 'package:flutter/material.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:lumotareas/models/user.dart';

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
    setState(() {
      _nombres = nombres;
    });
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
    return GestureDetector(
      onTap: () => _showMemberList(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: widget.miembros.isNotEmpty
                  ? const Color(0xFF6C63FF)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group,
                  color: widget.miembros.isNotEmpty
                      ? Colors.white
                      : Colors.black45,
                  size: 50,
                ),
                const SizedBox(height: 5),
                Text(
                  'Miembros',
                  style: TextStyle(
                    color: widget.miembros.isNotEmpty
                        ? Colors.white
                        : Colors.black45,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (widget.miembros.isNotEmpty)
            Positioned(
              top: -10,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${widget.miembros.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
