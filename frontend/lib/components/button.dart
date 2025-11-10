import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Button extends StatelessWidget {
  final IconData icon;
  final String text;
  final double iconSize;
  final Color color;
  final VoidCallback onPressed;
  final double textSize;

  const Button({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconSize = 20,
    this.textSize=13,
    this.color = const Color(0xFF001E3C),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: FaIcon(icon, size: iconSize, color: color),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
