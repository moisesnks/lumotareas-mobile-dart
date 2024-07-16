import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:lumotareas/lib/screens/home/home_screen.dart';
import 'package:lumotareas/lib/screens/profile/profile_screen.dart';
import 'package:lumotareas/lib/screens/settings/settings_screen.dart';
import 'package:lumotareas/lib/widgets/primary_header.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Lista de páginas disponibles
  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    // Usar un consumer del provider para obtener el usuario actual
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        final Usuario currentUser = userDataProvider.currentUser!;
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
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _pages,
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
        );
      },
    );
  }
}
