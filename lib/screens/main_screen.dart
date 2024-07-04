import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/widgets/header2.dart';
import 'main_screen/settings_bottom_sheet.dart';
import 'main_screen/membership_status.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/user.dart';
import 'main_screen/floating_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final _logger = Logger();
  final OrganizationService _organizationService = OrganizationService();
  DateTime? currentBackPressTime;
  bool redirectToLogin = false;
  String? currentOrganizationId;

  @override
  void initState() {
    super.initState();
    loadRedirectToLogin();
  }

  Future<void> loadRedirectToLogin() async {
    final redirectToLoginValue = await PreferenceService.getRedirectToLogin();
    final currentOrgId = await PreferenceService.getCurrentOrganization();
    setState(() {
      redirectToLogin = redirectToLoginValue;
      currentOrganizationId = currentOrgId;
    });
  }

  Widget _buildWelcomeTitle() {
    final currentUser = context.read<LoginViewModel>().currentUser;
    if (currentUser != null) {
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
    return const SizedBox();
  }

  Future<void> _setDefaultOrganization(LoginViewModel loginViewModel) async {
    if (currentOrganizationId == null &&
        loginViewModel.currentUser!.organizaciones!.isNotEmpty) {
      final firstOrganizationId =
          loginViewModel.currentUser!.organizaciones!.first.id;
      await PreferenceService.setCurrentOrganization(firstOrganizationId);
      setState(() {
        currentOrganizationId = firstOrganizationId;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SettingsBottomSheet(initialRedirectValue: redirectToLogin);
      },
    );
  }

  Widget _buildTitle(Usuario currentUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildWelcomeTitle(),
        const SizedBox(width: 10),
        MembershipStatusWidget(
            user: currentUser, organizationId: currentOrganizationId!)
      ],
    );
  }

  Widget _renderBody(Usuario currentUser, Organization organization) {
    if (organization.miembros > 0) {
      // Mostrar lista de miembros
      return ListView.builder(
        itemCount: organization.miembros,
        itemBuilder: (context, index) {
          // Aquí construyes cada elemento de la lista de miembros
          return ListTile(
            title: Text('Miembro ${index + 1}'),
          );
        },
      );
    } else {
      // Mostrar mensaje de que no hay miembros
      return const Center(
        child: Text('Su organización no tiene miembros'),
      );
    }
  }

  Widget _buildOrganizationBody(
      LoginViewModel loginViewModel, Usuario currentUser) {
    return Expanded(
      child: FutureBuilder(
        future: _organizationService.getOrganization(currentOrganizationId!),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }
          if (snapshot.hasData) {
            final Organization organization = snapshot.data!['organization'];
            return organization.miembros > 0
                ? _renderMembersList(organization)
                : RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'Aún no hay miembros en su organización, si '),
                        TextSpan(
                            text: 'desea agregarlos',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                ', puede hacerlo enviándoles una invitación.'),
                      ],
                    ),
                  );
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
        // Renderizar cada miembro aquí
        return ListTile(
          title: Text('Miembro ${index + 1}'),
        );
      },
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
          child: Center(
            child: Consumer<LoginViewModel>(
              builder: (context, loginViewModel, child) {
                final currentUser = loginViewModel.currentUser;
                if (currentUser != null) {
                  if (currentOrganizationId != null) {
                    _logger.i('Usuario actual: $currentUser');
                    _setDefaultOrganization(loginViewModel);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(
                          title: currentOrganizationId ?? 'LumoTareas',
                          onLogoTap: () {
                            _logger.i('Logo tapped!');
                          },
                          onSuffixTap: () {
                            _showBottomSheet(context);
                          },
                          suffixIcon:
                              const Icon(Icons.settings, color: Colors.white),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTitle(currentUser),
                                const SizedBox(height: 20),
                                _buildOrganizationBody(
                                    loginViewModel, currentUser),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingButtonMenu(),
      ),
    );
  }
}
