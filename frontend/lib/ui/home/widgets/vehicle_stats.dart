import 'package:flutter/material.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // add this dependency

class VehicleStatsCarousel extends StatefulWidget {
  const VehicleStatsCarousel({super.key});

  @override
  State<VehicleStatsCarousel> createState() => _VehicleStatsCarouselState();
}

class _VehicleStatsCarouselState extends State<VehicleStatsCarousel> {
  final List<Map<String, dynamic>> _stats = [
    {"icon": Icons.speed, "title": "12,345 km", "value": "Travelled"},
    {"icon": Icons.oil_barrel, "title": "Engine Oil", "value": "Good"},
    {"icon": Icons.water, "title": "Water Level", "value": "Optimal"},
    {
      "icon": Icons.security,
      "title": "Seat Belt Status",
      "value": "All Buckled",
    },
    {"icon": Icons.engineering, "title": "Engine Health", "value": "Excellent"},
    {"icon": Icons.ac_unit, "title": "AC Status", "value": "On"},
  ];

  late PageController _pageController;
  static const int _kMiddleValue = 10000;

  @override
  void initState() {
    super.initState();
    // Start in the middle so user can scroll left/right endlessly
    _pageController = PageController(initialPage: _kMiddleValue);
  }

  int get realIndex => _pageController.hasClients
      ? _pageController.page!.toInt() % _stats.length
      : 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              final stat = _stats[index % _stats.length]; // loop
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(stat["icon"], size: 40, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      stat["title"]!,
                      style: AppTheme.title.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stat["value"]!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
            onPageChanged: (index) => setState(() {}), // update indicator
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: _stats.length,
          effect: const WormEffect(
            dotHeight: 4,
            dotWidth: 8,
            spacing: 6,
            activeDotColor: Colors.blue,
          ),
          // map infinite page index to your data length
          onDotClicked: (i) {
            _pageController.animateToPage(
              _kMiddleValue + i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}
