import 'package:flutter/material.dart';

class ReelsBanner extends StatelessWidget {
  const ReelsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/reels_banner.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
