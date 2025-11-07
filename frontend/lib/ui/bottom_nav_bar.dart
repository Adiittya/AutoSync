import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(icon: FontAwesomeIcons.house, label: "Home", index: 0),
          _buildNavItem(icon: FontAwesomeIcons.calculator, label: "Remote", index: 1),
          _buildNavItem(
            icon: FontAwesomeIcons.carRear,
            label: "Status",
            index: 2,
          ),
          _buildNavItem(
            icon: FontAwesomeIcons.mapPin,
            label: "Map",
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? const Color(0xFF001E3C)
                  : const Color.fromARGB(179, 55, 55, 55),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTheme.navLabel.copyWith(
              color: isActive
                  ? const Color(0xFF001E3C)
                  : const Color.fromARGB(179, 55, 55, 55),
            )),
          ],
        ),
      ),
    );
  }
}
