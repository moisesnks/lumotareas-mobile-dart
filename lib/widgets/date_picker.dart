import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PickerDateComponent { day, month, year }

class DatePicker extends StatefulWidget {
  final DateTime? upperLimit;
  final DateTime? lowerLimit;
  final Function(DateTime) dateChangedCallback;

  const DatePicker({
    super.key,
    this.upperLimit,
    this.lowerLimit,
    required this.dateChangedCallback,
  });

  const DatePicker.upperLimit({
    super.key,
    this.upperLimit,
    required this.dateChangedCallback,
    this.lowerLimit,
  });

  const DatePicker.lowerLimit({
    super.key,
    this.lowerLimit,
    required this.dateChangedCallback,
    this.upperLimit,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime currentDate = DateTime.now().toLocal();
  DateTime today = DateTime.now().toLocal();

  @override
  void initState() {
    super.initState();

    if (widget.lowerLimit != null && currentDate.isBefore(widget.lowerLimit!)) {
      currentDate = widget.lowerLimit!;
    }
    if (widget.upperLimit != null && currentDate.isAfter(widget.upperLimit!)) {
      currentDate = widget.upperLimit!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return datePickerContainer();
  }

  Widget datePickerContainer() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Row(
        children: [
          // Day Wheel
          _wheelPicker(PickerDateComponent.day),
          // Month Wheel
          _wheelPicker(PickerDateComponent.month),
          // Year Wheel
          _wheelPicker(PickerDateComponent.year),
        ],
      ),
    );
  }

  Widget _wheelPicker(PickerDateComponent component) {
    List<String> items = [];
    int initialItemIndex = 0;

    if (component == PickerDateComponent.day) {
      for (int i = 1;
          i <= DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
          i++) {
        items.add(i.toString());
      }
      initialItemIndex = currentDate.day - 1;
    } else if (component == PickerDateComponent.month) {
      for (int i = 1; i <= 12; i++) {
        items.add(DateFormat.MMM().format(DateTime(0, i)));
      }
      initialItemIndex = currentDate.month - 1;
    } else if (component == PickerDateComponent.year) {
      int startYear = widget.lowerLimit?.year ?? today.year - 100;
      int endYear = widget.upperLimit?.year ?? today.year + 100;
      for (int i = startYear; i <= endYear; i++) {
        items.add(i.toString());
      }
      initialItemIndex = currentDate.year - startYear;
    }

    return Expanded(
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: initialItemIndex),
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.2,
        onSelectedItemChanged: (index) {
          setState(() {
            if (component == PickerDateComponent.day) {
              int newDay = index + 1;
              int maxDays =
                  DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
              if (newDay > maxDays) {
                newDay = maxDays;
              }
              currentDate =
                  DateTime(currentDate.year, currentDate.month, newDay);
            } else if (component == PickerDateComponent.month) {
              int newMonth = index + 1;
              int maxDays =
                  DateUtils.getDaysInMonth(currentDate.year, newMonth);
              if (currentDate.day > maxDays) {
                currentDate = DateTime(currentDate.year, newMonth, maxDays);
              } else {
                currentDate =
                    DateTime(currentDate.year, newMonth, currentDate.day);
              }
            } else if (component == PickerDateComponent.year) {
              currentDate = DateTime(
                  int.parse(items[index]), currentDate.month, currentDate.day);
            }

            // Ajustar la fecha si es inválida (por ejemplo, 29 de febrero en un año no bisiesto)
            if (component != PickerDateComponent.day) {
              int maxDays =
                  DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
              if (currentDate.day > maxDays) {
                currentDate =
                    DateTime(currentDate.year, currentDate.month, maxDays);
              }
            }

            // Sincronizar la UI con la fecha actual
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });

            widget.dateChangedCallback(currentDate);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: (component == PickerDateComponent.year &&
                          (index == initialItemIndex - 100 ||
                              index == initialItemIndex + 100))
                      ? Theme.of(context).disabledColor
                      : (index == initialItemIndex
                          ? Colors.blue
                          : Colors.black),
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
