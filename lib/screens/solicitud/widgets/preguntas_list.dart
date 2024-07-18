import 'package:flutter/material.dart';

class PreguntasList extends StatelessWidget {
  final Map<String, dynamic> preguntas;

  const PreguntasList({super.key, required this.preguntas});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, dynamic>> preguntasList =
        preguntas.entries.toList();

    return ListView.builder(
      itemCount: preguntasList.length,
      itemBuilder: (context, index) {
        final entry = preguntasList[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  const Icon(Icons.question_answer),
                  const SizedBox(width: 8.0),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                entry.value.toString(),
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
