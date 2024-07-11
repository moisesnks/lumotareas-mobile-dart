import 'package:flutter/material.dart';

class PreguntaPage extends StatelessWidget {
  final Map<String, dynamic> pregunta;
  final dynamic respuesta;
  final ValueChanged<dynamic> onChanged;

  const PreguntaPage({
    super.key,
    required this.pregunta,
    required this.respuesta,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${pregunta['enunciado'].toString()}${pregunta['required'] == true ? ' *' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (pregunta['tipo'] == 'seleccion_unica')
          ...pregunta['opciones']
              .map<Widget>((opcion) => RadioListTile(
                    title: Text(opcion),
                    value: opcion,
                    groupValue: respuesta,
                    onChanged: (value) => onChanged(value),
                  ))
              .toList(),
        if (pregunta['tipo'] == 'seleccion_multiple')
          ...pregunta['opciones']
              .map<Widget>((opcion) => CheckboxListTile(
                    title: Text(opcion),
                    value: respuesta.contains(opcion),
                    onChanged: (checked) {
                      if (checked!) {
                        onChanged([...respuesta, opcion]);
                      } else {
                        onChanged(respuesta..remove(opcion));
                      }
                    },
                  ))
              .toList(),
        if (pregunta['tipo'] == 'desarrollo')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLines: null,
                maxLength: pregunta['max_length'] ?? 150,
                initialValue: respuesta,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onChanged: (value) => onChanged(value),
              ),
            ],
          ),
      ],
    );
  }
}
