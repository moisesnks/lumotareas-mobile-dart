import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/main_body/descubrir_body/descubrir_body.dart';
import 'package:lumotareas/screens/main_screen/main_body/home_body/home_body.dart';
import 'package:lumotareas/screens/main_screen/main_body/profile_body/profile_body.dart';
import 'package:lumotareas/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header2.dart';
import 'package:lumotareas/models/user.dart';
import 'menu_flotante/main_floating_button.dart';
import 'settings_screen/screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final _logger = Logger();
  bool redirectToLogin = false;
  String currentOrganizationId = '';
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Usuario? _currentUser; // Define _currentUser as nullable Usuario

  @override
  void initState() {
    super.initState();
    loadInitialData(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadInitialData(BuildContext context) async {
    final redirectToLoginValue = await PreferenceService.getRedirectToLogin();
    final currentOrgId = await PreferenceService.getCurrentOrganization();

    setState(() {
      redirectToLogin = redirectToLoginValue;
      currentOrganizationId = currentOrgId ?? ''; // Handle null case
    });

    if (context.mounted) {
      final currentUser =
          Provider.of<LoginViewModel>(context, listen: false).currentUser;
      setState(() {
        _currentUser = currentUser; // Update _currentUser
      });

      if (currentOrganizationId.isEmpty &&
          currentUser != null &&
          currentUser.organizaciones != null &&
          currentUser.organizaciones!.isNotEmpty) {
        final String defaultOrganizationId =
            currentUser.organizaciones!.first.id;
        await PreferenceService.setCurrentOrganization(defaultOrganizationId);
        setState(() {
          currentOrganizationId = defaultOrganizationId;
        });
      } else {
        _logger.i('No se pudo establecer la organización por defecto');
      }
    }
  }

  void _setDefaultOrganization(Usuario currentUser) async {
    if (currentOrganizationId.isEmpty &&
        currentUser.organizaciones != null &&
        currentUser.organizaciones!.isNotEmpty) {
      final String defaultOrganizationId = currentUser.organizaciones!.first.id;
      await PreferenceService.setCurrentOrganization(defaultOrganizationId);
      setState(() {
        currentOrganizationId = defaultOrganizationId;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  String _getTitle(int index, String currentOrganizationId) {
    switch (index) {
      case 0:
        return currentOrganizationId.isNotEmpty
            ? currentOrganizationId
            : 'LumoTareas';
      case 1:
        return 'Descubrir';
      case 2:
        return 'Perfil';
      default:
        return 'LumoTareas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, loginViewModel, child) {
            final currentUser = loginViewModel.currentUser ?? _currentUser;
            if (currentUser != null) {
              _setDefaultOrganization(currentUser);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    title: _getTitle(_selectedIndex, currentOrganizationId),
                    onLogoTap: () {
                      _logger.i('Logo tapped!');
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
                      children: [
                        HomeBody(
                          currentOrganizationId: currentOrganizationId,
                          loginViewModel: loginViewModel,
                        ),
                        DescubrirBody(currentUser: currentUser),
                        const ProfileBody(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: _currentUser != null
            ? MainFloatingButton(
                mainIcon: _selectedIndex == 2 ? Icons.edit : Icons.add,
                currentUser: _currentUser!,
                currentPage: _selectedIndex == 0
                    ? 'home'
                    : _selectedIndex == 1
                        ? 'descubrir'
                        : 'perfil',
              )
            : null,
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            {'icon': Icons.home, 'label': 'Inicio'},
            {'icon': Icons.search, 'label': 'Descubrir'},
            {'icon': Icons.person, 'label': 'Perfil'},
          ],
        ),
      ),
    );
  }
}
