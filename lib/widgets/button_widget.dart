import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Icon? icon;
  final bool disabled;

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: disabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 100, 102, 168),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: const BorderSide(
          color: Color.fromARGB(255, 100, 102, 168),
          width: 2.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Titulo(texto: text),
          if (icon != null) const SizedBox(width: 8.0),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
