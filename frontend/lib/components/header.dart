import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/marquee_title.dart';
import 'package:frontend/constants/app_theme.dart';

class Header extends StatelessWidget {
  final int index;
  const Header({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    String title;
    bool useMarquee = false;

    // Decide title and style based on index
    switch (index) {
      case 0:
        title = 'Volkswagen Touareg R Hybrid';
        useMarquee = true; // only Home uses marquee
        break;
      case 1:
        title = 'Remote';
        break;
      case 2:
        title = 'Status';
        break;
      // case 3:
      //   title = 'Map';
      //   break;
      default:
        title = '';
    }

    return Row(
      children: [
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width / 1.5,
          child: useMarquee
              ? MarqueeTitle(text: title)
              : Text(title, style: AppTheme.mainTitle),
        ),
        const Spacer(),
        const FaIcon(FontAwesomeIcons.bell, size: 20, color: Colors.black87),
      ],
    );
  }
}
