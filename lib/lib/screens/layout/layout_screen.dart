import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:lumotareas/lib/providers/organization_data_provider.dart';
import 'package:lumotareas/lib/screens/crear_proyecto/crear_proyecto_screen.dart';
import 'package:lumotareas/lib/screens/home/home_screen.dart';
import 'package:lumotareas/lib/screens/profile/profile_screen.dart';
import 'package:lumotareas/lib/screens/settings/settings_screen.dart';
import 'package:lumotareas/lib/widgets/floating_menu.dart';
import 'package:lumotareas/lib/widgets/primary_header.dart';

import 'widgets/bottom_nav_bar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  LayoutScreenState createState() => LayoutScreenState();
}

class LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0; // Índice de la página seleccionada
  late PageController _pageController;
  Organizacion? _currentOrganization;

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
      setState(() {
        _currentOrganization = orgDataProvider.organization;
      });
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

  MenuFlotante _buildFloatingHomeMenu() {
    return MenuFlotante(
      mainIcon: Icons.add,
      items: const [
        {
          'icon': Icons.add,
          'label': 'Crear proyecto',
          'screen': CrearProyectoScreen()
        },
      ],
    );
  }

  MenuFlotante _buildFloatingProfileMenu() {
    return MenuFlotante(mainIcon: Icons.edit, items: const [
      {'icon': Icons.edit, 'label': 'Cambiar nombre'},
      {'icon': Icons.photo_camera, 'label': 'Cambiar foto'},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        final Usuario? currentUser = userDataProvider.currentUser;
        final bool loadingUser = userDataProvider.loadingUser;

        if (loadingUser) {
          return const Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
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
                  title: currentUser.currentOrg,
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
                  child: _currentOrganization == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          children: const [
                            HomeScreen(),
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
              {'icon': Icons.person, 'label': 'Perfil'},
            ],
          ),
          floatingActionButton: _selectedIndex == 0
              ? _buildFloatingHomeMenu()
              : _selectedIndex == 1
                  ? _buildFloatingProfileMenu()
                  : null,
        );
      },
    );
  }
}
