import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// 🔥 FETCH USER USING UID (anonymous login compatible)
  Future<void> loadUser() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  // Anonymous login → phone is stored in Firestore doc, not FirebaseAuth
  // 1️⃣ Retrieve all docs where uid == current user.uid
  final snap = await FirebaseFirestore.instance
      .collection("users")
      .where("uid", isEqualTo: user.uid)
      .limit(1)
      .get();

  if (snap.docs.isEmpty) {
    print("⚠ No user doc found for UID ${user.uid}");
    return;
  }

  final data = snap.docs.first.data();
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
                BookingDashboard(username: firstName ?? "User"),
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

            /// Floating Nav
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
