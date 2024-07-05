import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/models/organization.dart';
import './membership_status.dart';

class HomeBody extends StatelessWidget {
  final Logger _logger = Logger();
  final OrganizationService _organizationService = OrganizationService();

  final String currentOrganizationId;
  final LoginViewModel loginViewModel;

  HomeBody({
    super.key,
    required this.currentOrganizationId,
    required this.loginViewModel,
  });

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

  Widget _buildOrganizationBody(Usuario currentUser) {
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

  Widget buildSolicitudesContainer(int solicitudes, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tienes $solicitudes solicitudes pendientes',
              style: const TextStyle(
                fontSize: 12.0,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOrganizations(List<dynamic> solicitudes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actualmente, no estás afiliado a ninguna organización. Puedes crear tu propia organización o explorar otras existentes para enviar solicitudes de afiliación.',
          style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        const SizedBox(
            height: 16), // Espacio entre el texto y el siguiente contenido
        if (solicitudes.isNotEmpty)
          buildSolicitudesContainer(solicitudes.length, () {
            _logger.i('Mostrar solicitudes');
          }), // Mostrar el contenedor con el número de solicitudes
        if (solicitudes.isEmpty)
          const Text(
            'No tienes solicitudes pendientes',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget renderHomeBody(BuildContext context, Usuario currentUser) {
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
                    currentUser.organizaciones == null ||
                            currentUser.organizaciones!.isEmpty
                        ? _buildNoOrganizations(currentUser.solicitudes ?? [])
                        : _buildOrganizationBody(currentUser),
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
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        final currentUser = loginViewModel.currentUser;
        return currentUser != null
            ? renderHomeBody(context, currentUser)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
