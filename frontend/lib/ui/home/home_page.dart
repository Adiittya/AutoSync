import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/cards.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:frontend/controllers/mongo_controller.dart';

import 'package:frontend/ui/home/widgets/car_card.dart';
import 'package:frontend/ui/home/widgets/vehicle_stats.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MongoController mongoController = Get.put(MongoController());
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 20),

          Obx(() {
            if (mongoController.bookings.isEmpty) {
              return Container(
                height: 120, // height for horizontal scroll area
                child: Center(child: Text('No bookings found')),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Bookings",
                  style: AppTheme.title.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF001E3C),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 140, // fixed height for horizontal cards
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: mongoController.bookings.map((booking) {
                        return Container(
                          width: 220, // fixed width per card
                          margin: EdgeInsets.only(
                            right: 12,
                          ), // spacing between cards
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white, // card background
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 0),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 0),
                                blurRadius: 12,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 0),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    booking['service_type'] ?? '-',
                                    style: AppTheme.subtitle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    capitalize(booking['status']),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: booking['status'] == 'confirmed'
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    booking['preferred_date'] ?? '-',
                                    style: AppTheme.subtitle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    booking['preferred_time'] ?? '-',
                                    style: AppTheme.subtitle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),

                              Container(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }),

          SizedBox(height: 20),

          CustomCard(
            title: "Last Parked Location",
            showDetails: true,
            children: [
              Expanded(
                child: Text(
                  "Ashok Nagar Cross Road 1, Kandivali East, Mumbai, Maharashtra, 400101",
                  style: AppTheme.subtitle.copyWith(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          CustomCard(
            showDetails: true,
            title: "Digital Wallet",
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Driving Licence",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey[300]),

                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Vehicle Insurance",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey[300]),

                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Registration Certificate",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey[300]),

                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "PUC Certificate",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String capitalize(String? text) {
  if (text == null || text.isEmpty) return '-';
  return text[0].toUpperCase() + text.substring(1);
}
