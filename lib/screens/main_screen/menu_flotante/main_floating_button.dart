import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/widgets/menu_flotante_widget.dart';
import './items.dart';

class MainFloatingButton extends StatelessWidget {
  final IconData mainIcon;
  final Usuario currentUser;
  final String currentPage;

  const MainFloatingButton({
    super.key,
    required this.mainIcon,
    required this.currentUser,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final items = getFloatingButtonItems(currentUser, currentPage);

    return items.isNotEmpty
        ? MenuFlotante(
            mainIcon: mainIcon,
            items: items,
          )
        : Container();
  }
}
