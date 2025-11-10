import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/header.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:frontend/ui/bottom_nav_bar.dart';
import 'package:frontend/ui/chatbot/chat_page.dart';
import 'package:frontend/ui/home/home_page.dart';
import 'package:frontend/ui/map/map_page.dart';
import 'package:frontend/ui/remote/remote_page.dart';
import 'package:frontend/ui/status/status_page.dart';
import 'package:get/get.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // Replace with your actual pages/widgets
    HomePage(),
    RemotePage(),
    StatusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _currentIndex == 3
          ? MapPage()
          : Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 24.0,
                right: 24.0,
                bottom: 20.0,
              ),
              child: Column(
                children: [
                  Header(index: _currentIndex),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _pages[_currentIndex],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChatPage(), transition: Transition.cupertino);
        },
        backgroundColor: Color(0xFF001E3C),
        child: const FaIcon(FontAwesomeIcons.person, color: Colors.white),
      ),
    );
  }
}
