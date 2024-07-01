import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final void Function(bool isChecked) onChanged;

  const CheckboxWidget({
    super.key,
    required this.onChanged,
  });

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
              widget.onChanged(isChecked);
            });
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Acepto los términos y condiciones',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
