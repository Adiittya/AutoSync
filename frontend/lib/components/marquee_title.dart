import 'package:flutter/material.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:marquee/marquee.dart';

class MarqueeTitle extends StatelessWidget {
  final String text;
  const MarqueeTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Marquee text
        Marquee(
          text: text,
          style: AppTheme.mainTitle,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          blankSpace: 80.0,
          velocity: 50.0,
          pauseAfterRound: const Duration(seconds: 1),
          startPadding: 10.0,
          accelerationDuration: const Duration(milliseconds: 800),
          decelerationDuration: const Duration(milliseconds: 500),
        ),

        // Left gradient fade
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppTheme.background,
                  AppTheme.background.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        // Right gradient fade
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppTheme.background,
                  AppTheme.background.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
