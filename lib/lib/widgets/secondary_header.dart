import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isPoppable;
  final String title;

  const Header({
    super.key,
    this.onTap,
    this.isPoppable = false,
    this.title = 'Lumotareas',
  });

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
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isPoppable)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
