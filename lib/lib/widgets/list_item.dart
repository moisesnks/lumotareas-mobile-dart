// Widget genérico que muestra una lista de ítems utilizando un constructor de ítems personalizado.
library;

import 'package:flutter/material.dart';

/// Un widget genérico que muestra una lista de ítems utilizando un constructor de ítems personalizado.
class ListItems<T> extends StatelessWidget {
  final List<T> items; // Lista de ítems a mostrar
  final Widget Function(BuildContext context, T item)
      itemBuilder; // Función para construir cada ítem

  /// Constructor para crear una instancia de [ListItems].
  ///
  /// [items] es la lista de ítems a mostrar.
  /// [itemBuilder] es la función para construir cada ítem.
  const ListItems({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return itemBuilder(context, item);
      },
    );
  }
}
