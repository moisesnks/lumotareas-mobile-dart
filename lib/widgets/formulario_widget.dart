import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'date_picker_widget.dart';

class Formulario extends StatefulWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  const Formulario({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
  });

  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
  String? selectedDate;

  void showBirthdayDatePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              title: Text('Selecciona la fecha de tu cumpleaños'),
              leading: Icon(Icons.calendar_today),
            ),
            DatePicker(
              dateChangedCallback: (DateTime newDate) {
                setState(() {
                  selectedDate = DateFormat('dd/MM/yyyy').format(newDate);
                });
                // actualiza los controladores de texto
                widget.dayController.text = DateFormat('dd').format(newDate);
                widget.monthController.text = DateFormat('MM').format(newDate);
                widget.yearController.text = DateFormat('yyyy').format(newDate);
              },
              // Limita la selección de fechas
              upperLimit:
                  DateTime.now().subtract(const Duration(days: 18 * 365)),
              lowerLimit: DateTime(1950),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showBirthdayDatePickerModal(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191B5B),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedDate ?? 'Tu fecha de cumpleaños',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
