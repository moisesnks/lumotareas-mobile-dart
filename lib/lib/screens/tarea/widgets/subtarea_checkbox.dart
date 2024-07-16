import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';

class SubtareaCheckbox extends StatelessWidget {
  final Subtarea subtarea;
  final void Function(bool?)? onChanged; // Use nullable function type

  const SubtareaCheckbox({
    super.key,
    required this.subtarea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      key: key,
      title: Text(subtarea.name),
      subtitle: Text(subtarea.description),
      value: subtarea.done,
      onChanged: onChanged != null
          ? (bool? value) {
              onChanged!(value);
            }
          : null, // Pass null if onChanged is null
    );
  }
}
