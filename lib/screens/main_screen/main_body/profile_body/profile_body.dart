import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user-icon.png'),
            ),
            const SizedBox(height: 20),
            _buildProfileInfo('Nombre', currentUser.nombre),
            _buildProfileInfo('Correo Electrónico', currentUser.email),
            _buildProfileInfo('Fecha de Nacimiento', currentUser.birthdate),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007bff),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                // Funcionalidad para actualizar perfil
              },
              child: const Text('Actualizar Perfil'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Historial de Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Map<String, String>>>(
              future: Provider.of<LoginViewModel>(context, listen: false)
                  .getLoginHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar el historial de login');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay historial de login disponible');
                } else {
                  final loginHistory = snapshot.data!;
                  return Column(
                    children: loginHistory
                        .map((login) => _buildLoginHistory(
                            login['date']!, login['time']!, currentUser.nombre))
                        .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildLoginHistory(String date, String time, String userName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Logueado el $date a las $time'),
          Text(userName),
        ],
      ),
    );
  }
}
