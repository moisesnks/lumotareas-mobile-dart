import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/menu_flotante.dart';
import 'package:lumotareas/models/user.dart';
import './items.dart';

class AddFlotante extends StatelessWidget {
  final IconData mainIcon;
  final Usuario currentUser;

  const AddFlotante(
      {super.key, required this.mainIcon, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = getFloatingButtonItems(currentUser);

    return MenuFlotante(
      mainIcon: Icons.add,
      items: items,
    );
  }
}
