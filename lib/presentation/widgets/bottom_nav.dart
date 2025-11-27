import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int current;
  final Function(int) onTap;

  const BottomNav({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.withOpacity(0.25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 86, 86, 86).withOpacity(0.80),
              elevation: 0,
              type: BottomNavigationBarType.fixed,

              selectedItemColor: const Color(0xFFFF5E1F),
              unselectedItemColor: Colors.white60,

              showSelectedLabels: true,
              showUnselectedLabels: false,

              currentIndex: current,
              onTap: onTap,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  label: "More",
                ),

                /// ⭐ EXPLORE → HOME (new icon + new label)
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Home",
                ),

                /// ⭐ BOOKINGS → EXPLORE (same icon, only rename)
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_camera_back_rounded),
                  label: "Explore",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
