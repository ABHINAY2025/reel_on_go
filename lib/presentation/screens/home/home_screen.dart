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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;

  String? firstName;
  bool loading = true;

  late String phone;   // 🔥 store phone number

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUser();
  }

  /// 🔥 FETCH USER USING PHONE (NOT UID)
  Future<void> loadUser() async {
    phone = ModalRoute.of(context)!.settings.arguments as String;    // 🔥 FIXED

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
                  phone: phone,                // 🔥 FIXED
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

            /// BOTTOM NAVIGATION
            BottomNav(
              current: navIndex,
              onTap: (i) => setState(() => navIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}
