import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reel_on_go/presentation/widgets/bottom_nav.dart';
import 'package:reel_on_go/presentation/widgets/banner_slider.dart';
import 'package:reel_on_go/presentation/widgets/discover_section.dart';
import 'package:reel_on_go/presentation/widgets/reels_banner.dart';
import 'package:reel_on_go/presentation/widgets/partners_section.dart';
import 'package:reel_on_go/presentation/widgets/reviews_carousel.dart';
import 'package:reel_on_go/presentation/widgets/BrandFooterSection.dart';
import 'package:reel_on_go/presentation/bookings/booking_dashboard.dart';

class HomeScreen extends StatefulWidget {
  final String phone;

  const HomeScreen({super.key, required this.phone});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 1; // ⭐ Home tab index is 1

  String? firstName;
  bool loading = true;

  late String phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUser();
  }

  Future<void> loadUser() async {
    phone = ModalRoute.of(context)!.settings.arguments as String;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(phone)
        .get();

    if (!doc.exists) {
      print("⚠ No user document found for phone: $phone");
      setState(() => loading = false);
      return;
    }

    final data = doc.data()!;
    setState(() {
      firstName = data["firstName"] ?? "User";
      loading = false;
    });
  }

  // ⭐ NAVIGATION HANDLER (prevents stacking)
  void handleNavTap(int index) {
    if (index == navIndex) return; // already selected

    switch (index) {
      case 0: // More
        Navigator.pushReplacementNamed(
          context,
          "/more",
          arguments: phone,
        );
        break;

      case 1: // Home
        Navigator.pushReplacementNamed(
          context,
          "/home",
          arguments: phone,
        );
        break;

      case 2: // Explore
        Navigator.pushReplacementNamed(
          context,
          "/explore",
          arguments: phone,
        );
        break;

      case 3: // Profile
        Navigator.pushReplacementNamed(
          context,
          "/profile",
          arguments: phone,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                BookingDashboard(
                  username: firstName ?? "User",
                  phone: phone,
                ),
                const SizedBox(height: 30),

                const BannerSlider(),
                const SizedBox(height: 50),

                const DiscoverSection(),
                const SizedBox(height: 50),

                const ReelsBanner(),
                const SizedBox(height: 50),

                const PartnersSection(),
                const SizedBox(height: 50),

                const ReviewsCarousel(),
                const SizedBox(height: 120),

                const BrandFooterSection(),
                const SizedBox(height: 150),
              ],
            ),

            // ⭐ FIXED: Correct nav index + navigation
            BottomNav(
              current: navIndex,
              onTap: handleNavTap,
            ),
          ],
        ),
      ),
    );
  }
}
