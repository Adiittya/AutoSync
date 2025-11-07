import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/button.dart';
import 'package:frontend/components/cards.dart';
import 'package:frontend/constants/app_theme.dart';

class RemotePage extends StatelessWidget {
  const RemotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5,),
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
                "Volkswagen Touareg R Hybrid",
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
            title: "Remote",
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    icon: FontAwesomeIcons.lock,
                    text: "Lock",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  Button(
                    icon: FontAwesomeIcons.stop,
                    text: "Stop Engine",
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    icon: FontAwesomeIcons.powerOff,
                    text: "Start Engine",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),

                  Button(
                    icon: FontAwesomeIcons.lightbulb,
                    text: "Light / Honk",
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    icon: FontAwesomeIcons.lockOpen,
                    text: "Unlock",
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),

          CustomCard(
            title: "Climate Settings",
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemperatureSlider(),

                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Climate Settings",
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
                            "Defrost & Heat Setting",
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
                            "Seat Setting",
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
                            "Duration",
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

class TemperatureSlider extends StatefulWidget {
  const TemperatureSlider({super.key});

  @override
  State<TemperatureSlider> createState() => _TemperatureSliderState();
}

class _TemperatureSliderState extends State<TemperatureSlider> {
  double _currentTemperature = 20.0; // Initial temperature

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_currentTemperature.toStringAsFixed(1)}°C',
          style: AppTheme.title,
        ),
        Slider(
          activeColor: Colors.blue,
          value: _currentTemperature,
          min: 10.0, // Minimum temperature
          max: 30.0, // Maximum temperature
          divisions: 20, // For discrete steps of 1 degree
          label: _currentTemperature.toStringAsFixed(1),
          onChanged: (double newValue) {
            setState(() {
              _currentTemperature = newValue;
            });
          },
        ),
      ],
    );
  }
}
