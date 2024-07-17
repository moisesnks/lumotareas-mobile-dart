import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/pregunta.dart';

class PreguntaWidget extends StatelessWidget {
  final Pregunta pregunta;
  final ValueChanged<Pregunta> onChanged;

  const PreguntaWidget({
    super.key,
    required this.pregunta,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: pregunta.enunciado,
          decoration: const InputDecoration(
            labelText: 'Enunciado de la pregunta',
          ),
          onChanged: (value) {
            onChanged(pregunta.copyWith(enunciado: value));
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: pregunta.tipo,
          onChanged: (String? value) {
            onChanged(pregunta.copyWith(tipo: value ?? 'desarrollo'));
          },
          items: <String>[
            'seleccion_unica',
            'seleccion_multiple',
            'booleano',
            'desarrollo',
            'fecha',
            'subtareas',
            'formulario',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        CheckboxListTile(
          title: const Text('Requerido'),
          value: pregunta.required,
          onChanged: (value) {
            onChanged(pregunta.copyWith(required: value));
          },
        ),
        if (pregunta.tipo == 'seleccion_multiple')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Opciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              for (int i = 0; i < pregunta.opciones!.length; i++)
                TextFormField(
                  initialValue: pregunta.opciones![i].label,
                  decoration: InputDecoration(
                    labelText: 'Opción ${i + 1}',
                  ),
                  onChanged: (value) {
                    final List<Opcion> nuevasOpciones =
                        List.from(pregunta.opciones!);
                    nuevasOpciones[i] = Opcion(label: value, id: i.toString());
                    onChanged(pregunta.copyWith(opciones: nuevasOpciones));
                  },
                ),
              TextButton(
                onPressed: () {
                  final List<Opcion> nuevasOpciones =
                      List.from(pregunta.opciones!);
                  nuevasOpciones.add(
                      Opcion(label: '', id: nuevasOpciones.length.toString()));
                  onChanged(pregunta.copyWith(opciones: nuevasOpciones));
                },
                child: const Text('Agregar Opción'),
              ),
            ],
          ),
        const Divider(),
      ],
    );
  }
}
