import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarCard extends StatelessWidget {
  final String carImageAsset; // path to asset image

  const CarCard({super.key, required this.carImageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),

      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The box card
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
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
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.powerOff,
                          color: Colors.black87.withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "ON",
                          style: TextStyle(
                            color: Colors.black87.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.shareNodes, size: 15, color: Colors.white,), 
                          const SizedBox(width: 3,),
                          Text("Connected", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gasPump,
                          color: Colors.black87.withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "282 KM",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Car image positioned partially on top
          Positioned(
            top: -150,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 300,
              child: Image.asset(carImageAsset, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
