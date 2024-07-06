import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/entrada_texto_boton_widget.dart';

class BuscarOrganizacion extends StatelessWidget {
  final Function(String)? onSearch;

  BuscarOrganizacion({super.key, this.onSearch});

  final TextEditingController _controller = TextEditingController();
  final Logger _logger = Logger();

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
        if (onSearch != null) {
          onSearch!(searchText);
        }
      },
      fontColor: Colors.white,
      child: Transform.rotate(
        angle: 3.14 / 2,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
