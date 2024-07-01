import 'package:flutter/material.dart';

class FechaWidget extends StatefulWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  const FechaWidget({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
  });

  @override
  FechaWidgetState createState() => FechaWidgetState();
}

class FechaWidgetState extends State<FechaWidget> {
  List<int> days = List.generate(31, (index) => index + 1);
  List<int> months = List.generate(12, (index) => index + 1);

  // Calcular los años basados en el rango deseado
  late int maxYear;
  late int minYear;
  late List<int> years;

  List<int> filteredMonths = [];
  List<int> filteredYears = [];

  @override
  void initState() {
    super.initState();
    maxYear = DateTime.now().year - 18;
    minYear = DateTime.now().year - 100;
    years = List.generate(maxYear - minYear + 1, (index) => minYear + index);

    filteredMonths = List.from(months);
    filteredYears = List.from(years);
  }

  void updateMonths(int day) {
    setState(() {
      filteredMonths = months.where((month) {
        int maxDays = getMaxDaysInMonth(month,
            int.tryParse(widget.yearController.text) ?? DateTime.now().year);
        return day <= maxDays;
      }).toList();
      widget.monthController.text = '';
    });
  }

  void updateYears(int day, int month) {
    setState(() {
      filteredYears = years.where((year) {
        int maxDays = getMaxDaysInMonth(month, year);
        return day <= maxDays;
      }).toList();

      // Mantener el año seleccionado si es válido y bisiesto
      int selectedYear =
          int.tryParse(widget.yearController.text) ?? DateTime.now().year;
      if (filteredYears.contains(selectedYear) && isLeapYear(selectedYear)) {
        widget.yearController.text = selectedYear.toString();
      } else {
        // Buscar el año bisiesto más cercano dentro de los años filtrados
        int leapYear = filteredYears.firstWhere((year) => isLeapYear(year),
            orElse: () => filteredYears.last);
        widget.yearController.text = leapYear.toString();
      }
    });
  }

  int getMaxDaysInMonth(int month, int year) {
    switch (month) {
      case 2: // February
        return isLeapYear(year) ? 29 : 28;
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      default:
        return 31;
    }
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191B5B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonFormField<int>(
                      value: int.tryParse(widget.dayController.text),
                      decoration: const InputDecoration(
                        labelText: 'Día',
                        labelStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      items: days.map((day) {
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Text(
                            day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget.dayController.text = newValue.toString();
                          updateMonths(newValue ?? 1);
                          updateYears(newValue ?? 1,
                              int.tryParse(widget.monthController.text) ?? 1);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191B5B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonFormField<int>(
                      value: int.tryParse(widget.monthController.text),
                      decoration: const InputDecoration(
                        labelText: 'Mes',
                        labelStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      items: filteredMonths.map((month) {
                        return DropdownMenuItem<int>(
                          value: month,
                          child: Text(
                            month.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget.monthController.text = newValue.toString();
                          updateYears(
                              int.tryParse(widget.dayController.text) ?? 1,
                              newValue ?? 1);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191B5B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonFormField<int>(
                      value: int.tryParse(widget.yearController.text),
                      decoration: const InputDecoration(
                        labelText: 'Año',
                        labelStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      items: filteredYears.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(
                            year.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          widget.yearController.text = newValue.toString();
                          updateYears(
                              int.tryParse(widget.dayController.text) ?? 1,
                              int.tryParse(widget.monthController.text) ?? 1);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
