import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgentStatusChip extends StatelessWidget {
  final bool isActive;
  final String agentName;

  const AgentStatusChip({
    super.key,
    required this.isActive,
    required this.agentName,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isActive ? Colors.green.shade50 : Colors.grey.shade200;
    Color borderColor = isActive ? Colors.green.shade300 : Colors.grey.shade400;
    Color textColor = isActive ? Colors.green.shade800 : Colors.grey.shade600;
    Color dotColor = isActive ? Colors.green : Colors.grey;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            width: isActive ? 8 : 6,
            height: isActive ? 8 : 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? agentName : "Inactive",
            style: GoogleFonts.interTight(
              color: textColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
