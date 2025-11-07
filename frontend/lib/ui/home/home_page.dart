import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/cards.dart';

import 'package:frontend/ui/home/widgets/car_card.dart';
import 'package:frontend/ui/home/widgets/vehicle_stats.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CarCard(carImageAsset: "assets/images/car.webp"),
          SizedBox(height: 20),
          const VehicleStatsCarousel(),
          SizedBox(height: 20),

          CustomCard(
            title: "Remote",
            showIcon: true,
            showDetails: true,
            children: [
              Button(
                icon: FontAwesomeIcons.lock,
                text: "Lock",
                onPressed: () {},
              ),
              Button(
                icon: FontAwesomeIcons.powerOff,
                text: "Start Engine",
                onPressed: () {},
                iconSize: 25,
              ),
              Button(
                icon: FontAwesomeIcons.lockOpen,
                text: "Unlock",
                onPressed: () {},
              ),
            ],
          ),

          CustomCard(
            title: "Vehicle Status",
            children: [],
            showIcon: true,
            showDetails: true,
          ),
        ],
      ),
    );
  }
}
