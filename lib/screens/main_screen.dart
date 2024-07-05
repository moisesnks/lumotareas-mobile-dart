import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header2.dart';
import 'main_screen/settings_screen.dart';
import 'main_screen/membership_status.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/user.dart';
import 'main_screen/floating_button.dart';
import 'main_screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final _logger = Logger();
  final OrganizationService _organizationService = OrganizationService();
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

  Widget _buildWelcomeTitle(Usuario currentUser) {
    _logger.i('Renderizando título para ${currentUser.nombre}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hola ${currentUser.nombre.split(' ')[0]}',
            style: const TextStyle(
                fontSize: 24, fontFamily: 'Lexend', color: Colors.white))
      ],
    );
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

  Widget _buildTitle(Usuario currentUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildWelcomeTitle(currentUser),
        const SizedBox(width: 10),
        MembershipStatusWidget(
          user: currentUser,
          organizationId: currentOrganizationId,
        ),
      ],
    );
  }

  RichText _renderNoMembers() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(text: 'Aún no hay miembros en su organización, si '),
          TextSpan(
            text: 'desea agregarlos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ', puede hacerlo enviándoles una invitación.'),
        ],
      ),
    );
  }

  Widget _buildOrganizationBody(
    LoginViewModel loginViewModel,
    Usuario currentUser,
  ) {
    if (currentOrganizationId.isEmpty) {
      return const SizedBox();
    }
    return Expanded(
      child: FutureBuilder(
        future: _organizationService.getOrganization(currentOrganizationId),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }
          if (snapshot.hasData) {
            final Organization organization = snapshot.data!['organization'];
            _logger.i('Organización actual: $organization');
            return organization.miembros > 0
                ? _renderMembersList(organization)
                : _renderNoMembers();
          } else {
            return const Text('Error: No se pudo obtener la organización');
          }
        },
      ),
    );
  }

  Widget _renderMembersList(Organization organization) {
    return ListView.builder(
      itemCount: organization.miembros,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Miembro ${index + 1}'),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget renderHomeBody(LoginViewModel loginViewModel, Usuario currentUser) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(currentUser),
                    const SizedBox(height: 20),
                    currentUser.organizaciones == null ||
                            currentUser.organizaciones!.isEmpty
                        ? const Text('No hay organizaciones')
                        : _buildOrganizationBody(
                            loginViewModel,
                            currentUser,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/alone.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<LoginViewModel>(
            builder: (context, loginViewModel, child) {
              final currentUser = loginViewModel.currentUser;
              if (currentUser != null) {
                _setDefaultOrganization(currentUser);
                Widget bodyWidget;
                String title = 'LumoTareas';

                switch (_selectedIndex) {
                  case 0:
                    bodyWidget = renderHomeBody(loginViewModel, currentUser);
                    title = currentOrganizationId.isNotEmpty
                        ? currentOrganizationId
                        : 'LumoTareas';
                    break;
                  case 1:
                    bodyWidget = const ProfileScreen();
                    title = 'Perfil';
                    break;
                  default:
                    bodyWidget = renderHomeBody(loginViewModel, currentUser);
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
                            builder: (context) => SettingsScreen(
                              initialRedirectValue: redirectToLogin,
                            ),
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
        ),
        floatingActionButton: FloatingButtonMenu(
          currentUser: context.read<LoginViewModel>().currentUser!,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
