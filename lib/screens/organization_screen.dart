import 'package:flutter/material.dart';

class OrganizationDetailScreen extends StatelessWidget {
  final String orgName;

  const OrganizationDetailScreen({super.key, required this.orgName});

  // Método ficticio para simular la búsqueda de la organización
  Future<bool> _searchOrganization(String orgName) async {
    // Simulación de búsqueda asíncrona
    await Future.delayed(const Duration(seconds: 2));

    // Validar el nombre de la organización (solo reconocemos "Lumonidy", "lumonidy" o "LUMONIDY")
    bool organizationFound = orgName.toLowerCase() == "lumonidy";

    return organizationFound;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Detalles de $orgName'),
      ),
      body: FutureBuilder<bool>(
        future: _searchOrganization(orgName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Estado de carga mientras se realiza la búsqueda
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Manejo de error si ocurre algún problema durante la búsqueda
            return const Center(
              child: Text('Error al buscar la organización'),
            );
          } else if (snapshot.data == true) {
            // Si la organización fue encontrada, mostrar los detalles
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detalles de la organización $orgName',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Acción que se realiza al presionar el botón (opcional)
                    },
                    child: const Text('Realizar acción'),
                  ),
                ],
              ),
            );
          } else {
            // Si la organización no fue encontrada
            return Center(
              child: Text('La organización $orgName no fue encontrada'),
            );
          }
        },
      ),
    );
  }
}
