import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool showCount;
  final VoidCallback onTap;

  const IconBox({
    super.key,
    required this.icon,
    required this.label,
    this.count,
    this.showCount = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: count != null && count! > 0
                  ? const Color(0xFF6C63FF)
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: count != null && count! > 0
                      ? Colors.white
                      : Colors.black45,
                  size: 50,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: count != null && count! > 0
                        ? Colors.white
                        : Colors.black45,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (showCount && count != null && count! > 0)
            Positioned(
              top: -10,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
