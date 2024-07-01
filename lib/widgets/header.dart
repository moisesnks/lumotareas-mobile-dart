import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  final VoidCallback? onTap;

  const Header({super.key, this.onTap});

  Widget renderLogo() {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 36,
        height: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF191B5B),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          renderLogo(),
          const SizedBox(width: 8),
          const Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lumotareas',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
