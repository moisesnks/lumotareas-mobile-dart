import 'package:flutter/material.dart';

class Solicitudes extends StatelessWidget {
  final List<String> solicitudes;

  const Solicitudes({
    super.key,
    required this.solicitudes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: solicitudes.isNotEmpty
                  ? const Color(0xFF6C63FF)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.email,
              color: solicitudes.isNotEmpty ? Colors.white : Colors.black45,
              size: 30,
            ),
          ),
          if (solicitudes.isNotEmpty)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${solicitudes.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
