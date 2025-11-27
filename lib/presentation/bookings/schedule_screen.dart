import 'package:flutter/material.dart';
import '../screens/checkout/schedule_checkout/schedule_checkout.dart';  // 🔥 IMPORT CHECKOUT PAGE

class ScheduleScreen extends StatefulWidget {
  final String phone;

  const ScheduleScreen({super.key, required this.phone});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedTab = 0;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Schedule Shoot"),
        foregroundColor: Colors.white,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          /// ---------- TABS ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              tabButton("Quick Plans", 0),
              tabButton("Wedding Plans", 1),
              tabButton("Corporate", 2),
            ],
          ),

          const SizedBox(height: 20),

          /// ---------- PLAN CARDS ----------
          Expanded(
            child: PageView(
              controller: PageController(viewportFraction: 0.92),
              onPageChanged: (i) => setState(() => currentPage = i),
              children: _getPlans()
                  .asMap()
                  .entries
                  .map((entry) => buildPlanCard(entry.value, entry.key))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // TAB BUTTON
  // ------------------------------------------------------------------
  Widget tabButton(String title, int index) {
    bool active = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() {
        selectedTab = index;
        currentPage = 0;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFF5E1F) : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // WHICH PLANS TO SHOW
  // ------------------------------------------------------------------
  List<Map<String, dynamic>> _getPlans() {
    if (selectedTab == 0) return quickPlans;
    if (selectedTab == 1) return weddingPlans;
    return corporatePlans;
  }

  // ------------------------------------------------------------------
  // PLAN CARD UI
  // ------------------------------------------------------------------
  Widget buildPlanCard(Map<String, dynamic> plan, int index) {
    bool isSelected = currentPage == index;

    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width * 0.88,
            padding: const EdgeInsets.fromLTRB(22, 32, 22, 22),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF5E1F) : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  plan["subtitle"],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  plan["description"],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Text(
                      plan["price"],
                      style: const TextStyle(
                        color: Color(0xFFFF5E1F),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "+GST",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "What's included",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                ...plan["features"].map<Widget>((f) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFFF5E1F),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const Spacer(),

                /// ---------- 🔥 BOOK NOW BUTTON ----------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScheduleCheckoutScreen(
                            plan: plan,
                            phone: widget.phone,  // 🔥 pass phone
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E1F),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Book Now",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isSelected)
            Positioned(
              right: plan["tag"] != null ? 60 : 16,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5E1F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),

          if (plan["tag"] != null)
            Positioned(
              right: 16,
              top: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plan["tag"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// PLAN DATA (same as BookNowScreen)
/// ------------------------------------------------------------
final quickPlans = [
  {
    "tag": null,
    "title": "Hourly Plan",
    "subtitle": "Fast, Flexible & Impactful",
    "description":
        "Perfect for people who want a single, fast, high quality reel.",
    "price": "₹1,999",
    "features": [
      "1 Hour Shoot",
      "1 Edited Reel Delivered",
      "1 Reel Maker Onsite",
      "Shot on Latest iPhones",
      "Watermark Included",
    ]
  },
  {
    "tag": "🔥 Most Popular",
    "title": "Half Day Plan",
    "subtitle": "Built for Events",
    "description":
        "Quick, high quality coverage for events and social media delivered fast.",
    "price": "₹4,999",
    "features": [
      "Upto 3 Hours Shoot",
      "2 Edited Reels Delivered",
      "1 Reel Maker Onsite",
      "Raw Footage Access",
      "Shot on Latest iPhones",
      "Watermark Included",
    ]
  },
];

final weddingPlans = [
  {
    "tag": null,
    "title": "Starter Plan",
    "subtitle": "Single Event",
    "description":
        "Instant, pro-quality wedding reels fun, fast & stress free.",
    "price": "₹12,499",
    "features": [
      "Covers One Entire Event",
      "4 Reels Included",
      "Upto 2 Reel Makers Onsite",
      "Complementary Pictures",
      "Same Day Preview",
      "Raw Footage Access",
    ]
  },
  {
    "tag": "Wedding Package",
    "title": "Classic Plan",
    "subtitle": "Three Events",
    "description":
        "More moments, more magic crafted reels, delivered instantly.",
    "price": "₹34,999",
    "features": [
      "3 Events Covered",
      "12 Reels Included",
      "Same Day Preview",
      "Complementary Pictures",
      "Social Media Management",
    ]
  },
  {
    "tag": "⭐ Best Seller",
    "title": "Premium Plan",
    "subtitle": "Four Events",
    "description":
        "Seamless coverage, stunning reels — delivered before the night ends.",
    "price": "₹44,999",
    "features": [
      "4 Events Covered",
      "15 Reels Included",
      "Complementary Pictures",
      "Same Day Preview",
    ]
  },
  {
    "tag": null,
    "title": "Signature Plan",
    "subtitle": "Complete Wedding",
    "description":
        "Your wedding, reimagined with creative direction & timeless reels.",
    "price": "₹69,999",
    "features": [
      "6 Events Covered",
      "25 Reels Included",
      "150+ Pictures",
      "Dedicated Content Curator",
      "Live Stories",
    ]
  },
];

final corporatePlans = [
  {
    "tag": null,
    "title": "Single Day Event Plan",
    "subtitle": "Corporate Packages",
    "description":
        "Designed for brands needing scroll-stopping content from a single event.",
    "price": "₹9,999",
    "features": [
      "3 Reels Shot",
      "2 Reel Makers",
      "6 Hours Shoot",
      "Live Stories",
      "Raw Footage Access",
    ]
  },
  {
    "tag": "⭐ Best Seller",
    "title": "Monthly Creator Plan",
    "subtitle": "Corporate Packages",
    "description":
        "Designed for brands that need sharp monthly content and storytelling.",
    "price": "₹29,999",
    "features": [
      "10 High Impact Reels",
      "10 Hours Shoot",
      "Live Stories",
      "BTS Videos",
      "Interview Style Clips",
    ]
  },
];
