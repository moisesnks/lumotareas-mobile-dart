import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header2.dart';
import 'main_screen/settings_screen.dart';
import 'package:lumotareas/models/user.dart';
import 'main_screen/floating_button.dart';
import 'main_screen/profile_screen.dart';
import 'main_screen/bottom_navigation_bar.dart';

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

  @override
  void initState() {
    super.initState();
    loadInitialData(context);
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
    });
  }

  Widget buildSolicitudesContainer(int count, VoidCallback onPressed) {
    String mensaje;
    if (count == 1) {
      mensaje = 'Solicitud pendiente';
    } else {
      mensaje = 'Solicitudes pendientes';
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          const Icon(
            Icons.mail,
            size: 16.0,
            color: Colors.white,
          ),
          const SizedBox(width: 8.0),
          Text(
            mensaje,
            style: const TextStyle(
              fontSize: 12.0,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8.0),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // Función para construir la lista de solicitudes
  Widget buildSolicitudesList(List<dynamic> solicitudes) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: solicitudes.length,
      itemBuilder: (context, index) {
        String solicitudId = solicitudes[index];
        // Construye el UI para mostrar cada solicitudId
        return ListTile(
          title:
              Text(solicitudId), // Muestra el identificador de la solicitudId
          // Agrega más detalles según sea necesario
        );
      },
    );
  }

// Función principal para el widget _buildNoOrganizations

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, loginViewModel, child) {
            final currentUser = loginViewModel.currentUser;
            if (currentUser != null) {
              _setDefaultOrganization(currentUser);
              Widget bodyWidget;
              String title = 'LumoTareas';

              switch (_selectedIndex) {
                case 0:
                  bodyWidget = HomeBody(
                      currentOrganizationId: currentOrganizationId,
                      loginViewModel: loginViewModel);
                  title = currentOrganizationId.isNotEmpty
                      ? currentOrganizationId
                      : 'LumoTareas';
                  break;
                case 1:
                  bodyWidget = const Center(
                    child: Text('DescubrirPage'),
                  );
                  title = 'DescubrirPage';
                  break;
                case 2:
                  bodyWidget = const ProfileScreen();
                  title = 'Perfil';
                  break;
                default:
                  bodyWidget = HomeBody(
                      currentOrganizationId: currentOrganizationId,
                      loginViewModel: loginViewModel);
                  title = currentOrganizationId.isNotEmpty
                      ? currentOrganizationId
                      : 'LumoTareas';
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    title: title,
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
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: bodyWidget,
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
        floatingActionButton: FloatingButtonMenu(
          currentUser: context.read<LoginViewModel>().currentUser!,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        // Otros parámetros de configuración del BottomNavigationBar
      ),
    );
  }
}
