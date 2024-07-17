/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class ProfileWidget extends StatelessWidget {
  final Usuario currentUser;
  const ProfileWidget({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipOval(
          child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/user-icon.png',
        image: currentUser.photoURL,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) => const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/user-icon.png'),
        ),
      )),
      const SizedBox(height: 16),
      _buildProfileInfo('Nombre', currentUser.nombre),
      _buildProfileInfo('Correo', currentUser.email),
      _buildProfileInfo('Rol', currentUser.birthdate),
    ]);
  }

  Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ))
        ],
      ),
    );
  }
}
