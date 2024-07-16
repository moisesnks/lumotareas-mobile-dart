import 'package:flutter/material.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class SelectionModal<T> extends StatelessWidget {
  final String listTileTitle;
  final String modalTitle;
  final String alertTitle;
  final List<T> items;
  final String Function(T) displayField;
  final String Function(T)? subtitleField;
  final void Function(T) onSelected;
  final T initValue;
  final Color? backgroundColor;

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
