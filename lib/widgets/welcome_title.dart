import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget renderColumnTitle() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hola! Bienvenido a',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Color(0xFFFFFFFF),
          height: 1,
        ),
      ),
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
  );
}

Widget renderColumnTitle2() {
  return const Column(
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
  );
}

Widget renderLogo() {
  return SvgPicture.asset(
    'assets/images/logo.svg',
    width: 72,
    height: 72,
  );
}

Widget renderTitle() {
  return Row(
    children: [
      const SizedBox(width: 15),
      Expanded(
        flex: 7,
        child: renderColumnTitle(),
      ),
      Expanded(
        flex: 3,
        child: renderLogo(),
      ),
    ],
  );
}

Widget renderTitle2() {
  return Row(
    children: [
      const SizedBox(width: 15),
      Expanded(
        flex: 7,
        child: renderColumnTitle2(),
      ),
      Expanded(
        flex: 3,
        child: renderLogo(),
      ),
    ],
  );
}
