import 'package:flutter/material.dart';
import 'package:lumotareas/screens/main_screen/main_body/home_body/widgets/solicitudes.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/models/organization.dart';
import 'widgets/current_role.dart';

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

  Widget _buildTitle(BuildContext context, Usuario currentUser) {
    return Contenedor(
      direction: Axis.horizontal,
      height: 40,
      width: MediaQuery.of(context).size.width,
      children: [
        Titulo(texto: 'Hola ${currentUser.nombre.split(' ')[0]}'),
        const SizedBox(width: 40),
        CurrentRole(user: currentUser, organizationId: currentOrganizationId),
      ],
    );
  }

  Widget _renderMembers(BuildContext context, Organization organization) {
    if (organization.miembros > 0) {
      return Contenedor(
        direction: Axis.vertical,
        color: Colors.transparent,
        children: List.generate(
          organization.miembros,
          (index) => ListTile(
            title: Text('Miembro ${index + 1}'),
          ),
        ),
      );
    } else {
      return Contenedor(
        direction: Axis.vertical,
        width: MediaQuery.of(context).size.width,
        children: [
          RichText(
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
          ),
        ],
      );
    }
  }

  Widget _buildOrganizationSection(Usuario currentUser) {
    if (currentUser.organizaciones == null ||
        currentUser.organizaciones!.isEmpty ||
        currentOrganizationId.isEmpty) {
      return Contenedor(
        direction: Axis.vertical,
        color: const Color(0xFF1A1A1A),
        children: [
          const Parrafo(
            texto:
                'Actualmente, no estás afiliado a ninguna organización. Puedes crear tu propia organización o explorar otras existentes para enviar solicitudes de afiliación.',
          ),
          const SizedBox(height: 16),
          Solicitudes(
              solicitudes: currentUser.solicitudes?.length ?? 0,
              onTap: () {
                _logger.i('Solicitudes pendientes: ${currentUser.solicitudes}');
              }),
        ],
      );
    } else {
      return FutureBuilder(
        future: _organizationService.getOrganization(currentOrganizationId),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 10);
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }
          if (snapshot.hasData) {
            final Organization organization = snapshot.data!['organization'];
            _logger.i('Organización actual: $organization');
            return _renderMembers(context, organization);
          } else {
            return const Text('Error: No se pudo obtener la organización');
          }
        },
      );
    }
  }

  Widget _renderHomeBody(BuildContext context, Usuario currentUser) {
    return SafeArea(
      child: Contenedor(
        padding: const EdgeInsets.all(16),
        direction: Axis.vertical,
        color: const Color(0xFF1A1A1A),
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTitle(context, currentUser),
          const SizedBox(height: 16),
          _buildOrganizationSection(currentUser),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        final currentUser = loginViewModel.currentUser;
        return currentUser != null
            ? _renderHomeBody(context, currentUser)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
