// Widget que muestra una lista de selección en un modal.
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/styled_list_tile.dart';

/// Un widget que muestra una lista de selección en un modal.
class SelectionModal<T> extends StatelessWidget {
  final String listTileTitle; // Título del ListTile
  final String modalTitle; // Título del modal
  final String alertTitle; // Título de la alerta de confirmación
  final List<T> items; // Lista de elementos a mostrar en el modal
  final String Function(T)
      displayField; // Función para obtener el texto a mostrar de cada elemento
  final String Function(T)?
      subtitleField; // Función opcional para obtener el subtítulo de cada elemento
  final void Function(T)
      onSelected; // Callback cuando se selecciona un elemento
  final T initValue; // Valor inicial seleccionado
  final Color? backgroundColor; // Color de fondo del ListTile

  /// Constructor para crear una instancia de [SelectionModal].
  ///
  /// [listTileTitle] es el título del ListTile.
  /// [modalTitle] es el título del modal.
  /// [alertTitle] es el título de la alerta de confirmación.
  /// [items] es la lista de elementos a mostrar en el modal.
  /// [displayField] es la función para obtener el texto a mostrar de cada elemento.
  /// [subtitleField] es la función opcional para obtener el subtítulo de cada elemento.
  /// [onSelected] es el callback cuando se selecciona un elemento.
  /// [initValue] es el valor inicial seleccionado.
  /// [backgroundColor] es el color de fondo del ListTile.
  const SelectionModal({
    required this.listTileTitle,
    required this.modalTitle,
    required this.alertTitle,
    required this.items,
    required this.displayField,
    this.subtitleField,
    required this.onSelected,
    required this.initValue,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$listTileTitle: ${displayField(initValue)}'),
      tileColor: backgroundColor,
      onTap: () async {
        final selected = await showModalBottomSheet<T>(
          backgroundColor: const Color.fromARGB(155, 56, 45, 93),
          context: context,
          builder: (BuildContext context) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    modalTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return StyledListTile(
                        index: index,
                        leading: item == initValue
                            ? const Icon(Icons.star, color: Colors.yellow)
                            : const SizedBox(),
                        title: Text(displayField(item)),
                        subtitle: subtitleField != null
                            ? Text(subtitleField!(item))
                            : null,
                        onTap: () {
                          if (item != initValue) {
                            Navigator.of(context).pop(item);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );

        if (selected != null) {
          if (context.mounted) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    '$alertTitle ${displayField(selected)}?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Confirmar'),
                    ),
                  ],
                );
              },
            );
            if (confirmed ?? false) {
              onSelected(selected);
            }
          }
        }
      },
    );
  }
}
