import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:logger/logger.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key});

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser;
    _logger.d('currentUser: $currentUser');

    return currentUser == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/user-icon.png',
                  image: currentUser.photoURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    _logger.e('Error cargando avatar: $error');
                    return const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/user-icon.png'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileInfo('Nombre', currentUser.nombre),
              _buildProfileInfo('Correo Electrónico', currentUser.email),
              _buildProfileInfo('Fecha de Nacimiento', currentUser.birthdate),
            ],
          );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
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
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            // Utilizar Expanded para que el valor ocupe el espacio restante
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow
                    .ellipsis, // Mostrar puntos suspensivos si el texto es demasiado largo
                maxLines: 1, // Limitar a una línea de texto
              ),
            ),
          ),
        ],
      ),
    );
  }
}
