import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../screens/profileSetup/profile_setup_screen.dart';
import '../widgets/bottom_nav.dart';

class MainWrapper extends StatefulWidget {
  final String phone;
  const MainWrapper({super.key, required this.phone});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const Placeholder(color: Colors.white),
      HomeScreen(phone: widget.phone),
      ExploreScreen(phone: widget.phone),
      ProfileSetupScreen(phone: widget.phone),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          screens[index],
          BottomNav(
            current: index,
            onTap: (i) => setState(() => index = i),
          ),
        ],
      ),
    );
  }
}
