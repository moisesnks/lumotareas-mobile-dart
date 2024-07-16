import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginTitulo extends StatelessWidget {
  const LoginTitulo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lumotareas ',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color(0xFFFFFFFF),
                  height: 1,
                ),
              ),
              Text(
                'Todo el potencial de un equipo ágil al alcance de tu móvil',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Color(0xFFC9B8F9),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: SvgPicture.asset('assets/images/logo.svg',
              height: 200, width: 200),
        ),
      ],
    );
  }
}
