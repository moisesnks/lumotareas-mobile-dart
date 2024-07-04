import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback? onLogoTap;
  final VoidCallback? onSuffixTap;
  final Widget? suffixIcon;

  const Header({
    super.key,
    required this.title,
    this.onLogoTap,
    this.onSuffixTap,
    this.suffixIcon,
  });

  Widget renderLogo() {
    return GestureDetector(
      onTap: onLogoTap,
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
          Column(
            children: [
              renderLogo(),
              const SizedBox(height: 4),
              const Text('Lumotareas',
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontFamily: 'Lexend')),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              child: Container(
                decoration: const BoxDecoration(),
                width: MediaQuery.of(context).size.width * .6,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (suffixIcon != null)
            GestureDetector(
              onTap: onSuffixTap,
              child: suffixIcon!,
            ),
        ],
      ),
    );
  }
}
