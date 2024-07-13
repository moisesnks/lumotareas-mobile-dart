import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/entrada_texto_boton_widget.dart';
import '../../../../../../logic/descubrir_logic.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/screens/detalle_org/detalle_org_screen.dart';

class BuscarOrganizacion extends StatefulWidget {
  const BuscarOrganizacion({super.key});

  @override
  BuscarOrganizacionState createState() => BuscarOrganizacionState();
}

class BuscarOrganizacionState extends State<BuscarOrganizacion> {
  final TextEditingController _controller = TextEditingController();
  final Logger _logger = Logger();

  void _buildModal(BuildContext context, List<Organization> organizations) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: organizations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(organizations[index].nombre),
              onTap: () {
                // _showOrganizationDetailsDialog(context, organizations[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleOrgScreen(
                      organization: organizations[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _searchOrganizations(BuildContext context, String query) async {
    final result = await DescubrirLogic.buscarOrganizaciones(query);
    if (result['success']) {
      final List<Organization> organizations = result['organizations'];

      if (context.mounted) {
        _buildModal(context, organizations);
      }
    } else {
      final message = result['message'];
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return EntradaTextoConBoton(
      controller: _controller,
      labelText: 'Buscar organizaciones...',
      buttonText: 'Buscar',
      onPressed: () {
        // Cierra el teclado
        FocusScope.of(context).unfocus();

        String searchText = _controller.text;
        _logger.d('Buscando $searchText...');
        _searchOrganizations(context, searchText);
      },
      fontColor: Colors.white,
      child: Transform.rotate(
        angle: 3.14 / 2,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
