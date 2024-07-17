import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/subtarea.dart';

class SubtareaWidget extends StatelessWidget {
  final Subtarea subtarea;
  final ValueChanged<Subtarea> onChanged;

  const SubtareaWidget({
    super.key,
    required this.subtarea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: subtarea.name,
          decoration: const InputDecoration(
            labelText: 'Nombre de la subtarea',
          ),
          onChanged: (value) {
            onChanged(subtarea.copyWith(name: value));
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: subtarea.description,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Descripción de la subtarea',
          ),
          onChanged: (value) {
            onChanged(subtarea.copyWith(description: value));
          },
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text('Completado'),
          value: subtarea.done,
          onChanged: (value) {
            onChanged(subtarea.copyWith(done: value));
          },
        ),
        const Divider(),
      ],
    );
  }
}
