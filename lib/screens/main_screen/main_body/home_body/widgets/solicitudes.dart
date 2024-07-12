import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';

class Solicitudes extends StatelessWidget {
  final List<String> solicitudes;

  const Solicitudes({
    super.key,
    required this.solicitudes,
  });

  void _showRequestList(BuildContext context) {
    if (solicitudes.isNotEmpty) {
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
                    'Lista de solicitudes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: solicitudes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          solicitudes[index],
                          style: const TextStyle(color: Colors.white),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sin solicitudes'),
            content: const Text('No tienes solicitudes pendientes.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.email,
      label: 'Solicitudes',
      count: solicitudes.length,
      showCount: true,
      onTap: () => _showRequestList(context),
    );
  }
}
