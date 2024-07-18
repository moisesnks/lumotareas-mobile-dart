import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/crear_organizacion/crear_organizacion_screen.dart';
import 'package:lumotareas/screens/descubrir/descubrir_screen.dart';
import 'package:provider/provider.dart';

import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/providers/organization_data_provider.dart';
import 'package:lumotareas/screens/crear_proyecto/crear_proyecto_screen.dart';
import 'package:lumotareas/screens/home/home_screen.dart';
import 'package:lumotareas/screens/profile/profile_screen.dart';
import 'package:lumotareas/screens/settings/settings_screen.dart';
import 'package:lumotareas/widgets/floating_menu.dart';
import 'package:lumotareas/widgets/primary_header.dart';

import 'widgets/bottom_nav_bar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  LayoutScreenState createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0; // Índice de la página seleccionada
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _fetchOrganization();
  }

  Future<void> _fetchOrganization() async {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final orgDataProvider =
        Provider.of<OrganizationDataProvider>(context, listen: false);

    final Usuario? currentUser = userDataProvider.currentUser;
    if (currentUser != null && currentUser.currentOrg.isNotEmpty) {
      await orgDataProvider.fetchOrganization(context, currentUser.currentOrg);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Método para cambiar de página
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  MenuFlotante _buildFloatingHomeMenu(Usuario currentUser) {
    return MenuFlotante(
        mainIcon: Icons.menu,
        items: currentUser.currentOrg.isEmpty
            ? [
                {
                  'icon': Icons.add,
                  'label': 'Crear organización',
                  'screen': const CrearOrganizacionScreen(),
                },
              ]
            : [
                {
                  'icon': Icons.add,
                  'label': 'Crear proyecto',
                  'screen': const CrearProyectoScreen(),
                },
                {
                  'icon': Icons.add,
                  'label': 'Crear proyecto',
                  'screen': const CrearProyectoScreen(),
                },
              ]);
  }

  MenuFlotante _buildFloatingProfileMenu(Usuario currentUser) {
    return MenuFlotante(mainIcon: Icons.edit, items: [
      {
        'icon': Icons.edit,
        'label': 'Cambiar nombre',
        'screen': ChangeNameDialog(currentUser: currentUser)
      },
      const {'icon': Icons.photo_camera, 'label': 'Cambiar foto'},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        final Usuario? currentUser = userDataProvider.currentUser;
        final bool loadingUser = userDataProvider.loadingUser;

        if (loadingUser) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Obteniendo información del usuario...'),
                  ],
                ),
              ),
            ),
          );
        }

        if (currentUser == null) {
          return const Scaffold(
            body: SafeArea(
              child: Center(
                child: Text('No se encontró el usuario'),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: _selectedIndex == 0
                      ? currentUser.currentOrg.isNotEmpty
                          ? currentUser.currentOrg
                          : 'Inicio'
                      : _selectedIndex == 1
                          ? 'Descubrir'
                          : 'Perfil',
                  onLogoTap: () {
                    Logger().i('Logo tapped!');
                  },
                  suffixIcon: const Icon(Icons.settings),
                  onSuffixTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: const [
                      HomeScreen(),
                      DescubrirScreen(),
                      ProfileScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              {'icon': Icons.home, 'label': 'Inicio'},
              {'icon': Icons.search, 'label': 'Descubrir'},
              {'icon': Icons.person, 'label': 'Perfil'},
            ],
          ),
          floatingActionButton: _selectedIndex == 0
              ? _buildFloatingHomeMenu(currentUser)
              : _selectedIndex == 2
                  ? _buildFloatingProfileMenu(currentUser)
                  : null,
        );
      },
    );
  }
}
