import 'package:flutter/material.dart';
import 'package:lumotareas/models/question.dart';

class PreguntaPage extends StatelessWidget {
  final Question pregunta;
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
    // Convertir respuesta de String a bool si es necesario
    bool? boolRespuesta;
    if (respuesta is String) {
      boolRespuesta = respuesta == 'true';
    } else if (respuesta is bool) {
      boolRespuesta = respuesta;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${pregunta.enunciado}${pregunta.required ? ' *' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (pregunta.tipo == 'seleccion_unica')
          ...pregunta.opciones.map<Widget>((opcion) => RadioListTile(
                title: Text(opcion.label),
                value: opcion.id, // Usar opcion.id como valor
                groupValue: respuesta,
                onChanged: (value) => onChanged(value),
              )),
        if (pregunta.tipo == 'seleccion_multiple')
          ...pregunta.opciones.map<Widget>((opcion) => CheckboxListTile(
                title: Text(opcion.label),
                value: respuesta != null &&
                    respuesta
                        .contains(opcion.id), // Usar opcion.id para comparar
                onChanged: (checked) {
                  List<String> newRespuesta = List.from(respuesta ?? []);
                  if (checked!) {
                    newRespuesta.add(opcion.id); // Usar opcion.id correctamente
                  } else {
                    newRespuesta
                        .remove(opcion.id); // Usar opcion.id correctamente
                  }
                  onChanged(newRespuesta);
                },
              )),
        if (pregunta.tipo == 'desarrollo')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLines: null,
                maxLength: pregunta.maxLength ?? 150,
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
        if (pregunta.tipo == 'booleano')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: const Text('Sí'),
                value: true,
                groupValue: boolRespuesta,
                onChanged: (value) => onChanged(value), // value es bool
              ),
              RadioListTile(
                title: const Text('No'),
                value: false,
                groupValue: boolRespuesta,
                onChanged: (value) => onChanged(value), // value es bool
              ),
            ],
          ),
      ],
    );
  }
}
