import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/models/user.dart';
import 'widgets/current_role.dart';
import 'widgets/organization_section.dart';
import 'package:lumotareas/services/organization_service.dart';

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

  Widget _renderHomeBody(BuildContext context, Usuario currentUser) {
    return SafeArea(
      child: Contenedor(
        padding: const EdgeInsets.all(16),
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTitle(context, currentUser),
          const SizedBox(height: 16),
          OrganizationSection(
            currentOrganizationId: currentOrganizationId,
            logger: _logger,
            organizationService: _organizationService,
          ),
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
