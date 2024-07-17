import 'package:flutter/material.dart';
import 'box_label.dart';

class TextfieldButton extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onPressed;
  final String buttonText;
  final Color borderColor;
  final Color labelBackgroundColor;
  final Color fontColor;
  final Widget child;

  TextfieldButton({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onPressed,
    required this.buttonText,
    this.borderColor = const Color.fromARGB(255, 100, 102, 168),
    this.labelBackgroundColor = const Color.fromARGB(255, 7, 8, 29),
    this.fontColor = const Color.fromARGB(255, 100, 102, 168),
    Widget? child,
  }) : child = child ?? Icon(Icons.arrow_forward, color: fontColor);

  @override
  Widget build(BuildContext context) {
    return BoxLabel(
      fontColor: fontColor,
      labelText: labelText,
      labelBackgroundColor: labelBackgroundColor,
      borderColor: borderColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: const BorderSide(
                color: Color.fromARGB(255, 100, 102, 168),
                width: 0,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 14,
                      color: fontColor,
                    ),
                  ),
                  const SizedBox(width: 2),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
