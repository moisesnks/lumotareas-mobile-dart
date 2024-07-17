import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/organizacion/organizacion_screen.dart';
import 'package:lumotareas/widgets/styled_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/providers/descubrir_data_provider.dart';
import 'package:lumotareas/widgets/textfield_button.dart'; // Importa el widget TextfieldButton

class BuscarOrganizacion extends StatefulWidget {
  const BuscarOrganizacion({super.key});

  @override
  BuscarOrganizacionState createState() => BuscarOrganizacionState();
}

class BuscarOrganizacionState extends State<BuscarOrganizacion> {
  final TextEditingController _controller = TextEditingController();
  List<Organizacion> _resultadosBusqueda = [];

  void _buscarOrganizacion(BuildContext context, String query) async {
    if (query.isNotEmpty) {
      final resultados =
          await Provider.of<DescubrirDataProvider>(context, listen: false)
              .obtenerOrganizaciones(query);
      setState(() {
        _resultadosBusqueda = resultados;
      });
      if (context.mounted) {
        _buildModal(context, _resultadosBusqueda);
      }
    } else {
      setState(() {
        _resultadosBusqueda = [];
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se ha encontrado ninguna organización'),
          ),
        );
      }
    }
  }

  void _seleccionarOrganizacion(Organizacion organizacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrganizacionDetalleScreen(organizacion: organizacion),
      ),
    );
  }

  void _buildModal(BuildContext context, List<Organizacion> organizaciones) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: organizaciones.length,
          itemBuilder: (context, index) {
            final organizacion = organizaciones[index];
            return StyledListTile(
              index: index,
              title: Text(organizacion.nombre),
              subtitle: Text(organizacion.descripcion),
              onTap: () => _seleccionarOrganizacion(organizacion),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Usa TextfieldButton en lugar de TextField directamente
        TextfieldButton(
          controller: _controller,
          labelText: 'Buscar organización',
          onPressed: () {
            FocusScope.of(context).unfocus(); // Cierra el teclado
            String searchQuery = _controller.text;
            Logger().d('Buscando organización: $searchQuery');
            _buscarOrganizacion(context, searchQuery);
          },
          buttonText: 'Buscar',
          fontColor: Colors.white,
          child: Transform.rotate(
            angle: 3.14 / 2,
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
        // if (_resultadosBusqueda.isNotEmpty)
        //   Expanded(
        //     child: ListView.builder(
        //       itemCount: _resultadosBusqueda.length,
        //       itemBuilder: (context, index) {
        //         final organizacion = _resultadosBusqueda[index];
        //         return ListTile(
        //           title: Text(organizacion.nombre),
        //           onTap: () => _seleccionarOrganizacion(organizacion),
        //         );
        //       },
        //     ),
        //   ),
      ],
    );
  }
}
