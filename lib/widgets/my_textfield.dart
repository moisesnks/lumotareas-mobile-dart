import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final String hintText;
  final bool
      isPassword; // Nueva propiedad para determinar si es campo de contraseña

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.hintText,
    this.isPassword = false, // Valor por defecto es false
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late bool obscureText = widget.isPassword;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              obscureText: widget.isPassword && obscureText,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                filled: true,
                fillColor: const Color(0xFF191B5B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
          Positioned(
            top: -16,
            right: -16,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(widget.labelText),
                      content: Text(widget.hintText),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              // GestureDetector wraps the entire Container content
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
