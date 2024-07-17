// Widget ListTile personalizado con estilo y colores alternos.
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/utils/constants.dart';

/// Un widget [StyledListTile] que proporciona un estilo personalizado para ListTile con colores alternos.
class StyledListTile extends StatelessWidget {
  final int index; // Índice del elemento en la lista
  final Widget? leading; // Widget opcional a mostrar antes del título
  final Widget title; // Widget que muestra el título del ListTile
  final Widget?
      subtitle; // Widget opcional que muestra el subtítulo del ListTile
  final Widget? trailing; // Widget opcional a mostrar después del título
  final void Function()? onTap; // Callback cuando se toca el ListTile

  /// Constructor para crear una instancia de [StyledListTile].
  ///
  /// [index] es el índice del elemento en la lista.
  /// [title] es el widget que muestra el título del ListTile.
  /// [subtitle] es el widget opcional que muestra el subtítulo del ListTile.
  /// [onTap] es el callback cuando se toca el ListTile.
  /// [leading] es el widget opcional a mostrar antes del título.
  /// [trailing] es el widget opcional a mostrar después del título.
  const StyledListTile({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemBackgroundColor =
        index.isOdd ? primaryColor : secondaryColor;
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      tileColor: itemBackgroundColor,
      onTap: onTap,
    );
  }
}
