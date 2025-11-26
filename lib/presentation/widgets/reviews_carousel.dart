import 'package:flutter/material.dart';

class ReviewsCarousel extends StatelessWidget {
  const ReviewsCarousel({super.key});

  final List<Map<String, String>> reviews = const [
    {
      "name": "Aarav Sharma",
      "image": "assets/images/user1.jpg",
      "review": "Amazing shoot quality! Fast delivery and super smooth workflow."
    },
    {
      "name": "Kritika Rao",
      "image": "assets/images/user1.jpg",
      "review": "Professional reel makers! They captured exactly what I imagined."
    },
    {
      "name": "Rohit Verma",
      "image": "assets/images/user1.jpg",
      "review": "Loved the cinematic output. Quick edits & top-notch creativity!"
    },
    {
      "name": "Simran Kaur",
      "image": "assets/images/user1.jpg",
      "review": "Super friendly team. My best reels till date! 🔥"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Reviews",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.88),
            physics: const BouncingScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Stack(
                    children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      AssetImage(reviews[index]["image"]!),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  reviews[index]["name"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              "\"${reviews[index]["review"]!}\"",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
