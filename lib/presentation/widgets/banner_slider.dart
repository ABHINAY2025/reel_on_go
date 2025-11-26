import 'package:flutter/material.dart';
import 'dart:async';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final ScrollController scrollController = ScrollController();
  int index = 0;
  Timer? autoScrollTimer;

  final List<String> banners = [
    "assets/images/banner1.jpeg",
    "assets/images/banner2.jpeg",
    "assets/images/banner3.jpeg",
    "assets/images/banner4.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(updateIndexFromScroll);

    /// 🔥 Auto-scroll every 5 seconds
    autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      autoScroll();
    });
  }

  void autoScroll() {
    final double bannerWidth =
        MediaQuery.of(context).size.width * 0.82 + 12;

    int nextIndex = (index + 1) % banners.length;

    scrollController.animateTo(
      nextIndex * bannerWidth,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void updateIndexFromScroll() {
    double bannerWidth =
        MediaQuery.of(context).size.width * 0.82 + 12;

    int newIndex = (scrollController.offset / bannerWidth).round();

    if (newIndex != index &&
        newIndex >= 0 &&
        newIndex < banners.length) {
      setState(() => index = newIndex);
    }
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bannerWidth = MediaQuery.of(context).size.width * 0.82;

    return Column(
      children: [
        /// ⭐ Horizontal Banner Scroll
        SizedBox(
          height: 170,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: banners.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 4 : 12,
                  right: i == banners.length - 1 ? 4 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    scrollController.animateTo(
                      i * (bannerWidth + 12),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: bannerWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: AssetImage(banners[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        /// ⭐ Dot Indicators (Reactive)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => GestureDetector(
              onTap: () {
                scrollController.animateTo(
                  i * (bannerWidth + 12),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == i ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == i
                      ? const Color(0xFFFF5E1F)
                      : Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
