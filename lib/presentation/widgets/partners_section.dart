import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  final List<Map<String, String>> partners = const [
    {
      "name": "Aarav Films",
      "rating": "4.8",
      "image": "assets/images/partner1.jpeg",
    },
    {
      "name": "Studio Nexa",
      "rating": "4.9",
      "image": "assets/images/partner2.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Partners of the Week",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
          ],
        ),

        const SizedBox(height: 14),

        /// ⭐ FULL SCREEN SLIDER WITH GAP
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: PageController(viewportFraction: 1.0), 
            // 👆 0.88 gives spacing on both sides
            itemCount: partners.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10), // ✨ spacing
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: width * 0.88,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(partners[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(18),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partners[index]["name"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                partners[index]["rating"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
