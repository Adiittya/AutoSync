import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/cards.dart';
import 'package:frontend/constants/app_theme.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,

                borderRadius: BorderRadius.circular(100),
              ),
              child: FaIcon(
                FontAwesomeIcons.shareNodes,
                size: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "Volkswagen Touareg R Hybrid ",
              style: AppTheme.title.copyWith(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomCard(
          title: "",
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "285 km",
                    style: AppTheme.title.copyWith(
                      color: Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                  Text("Range"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text("E"),
                      SizedBox(width: 8), // optional spacing
                      Expanded(child: SimpleLinearIndicator(value: 0.7)),
                      SizedBox(width: 8),
                      Text("F"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomCard(
          title: "Engine / Lock Status",
          showDetails: true,
          children: [
            // const SizedBox(height: 30,),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
                  
            //       Column(
            //         children: [
            //           FaIcon(FontAwesomeIcons.powerOff),
            //           const SizedBox(height: 5),
            //           Text("Off"),
            //         ],
            //       ),
              
            //       VerticalDivider(width: 1, thickness: 1,),
            //       Column(
            //         children: [
            //           FaIcon(FontAwesomeIcons.unlock),
            //           const SizedBox(height: 5),
            //           Text("Locked"),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        CustomCard(title: "Others", showDetails: true),
        CustomCard(
          title: "Vehicle Management",
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle Report",
                  style: AppTheme.subtitle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                Text(
                  "Informs you of the regular vehicle inspections results",
                  style: AppTheme.subtitle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SimpleLinearIndicator extends StatelessWidget {
  final double? value;
  final Color color;
  final Color backgroundColor;
  final double height;

  const SimpleLinearIndicator({
    super.key,
    this.value,
    this.color = Colors.blue,
    this.backgroundColor = const Color(0xFFE0E0E0), // light grey
    this.height = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: LinearProgressIndicator(
        value: value,
        color: color,
        backgroundColor: backgroundColor,
        minHeight: height,
      ),
    );
  }
}
