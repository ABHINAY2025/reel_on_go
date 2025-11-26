import 'dart:ui';
import 'package:flutter/material.dart';

class BrandFooterSection extends StatefulWidget {
  const BrandFooterSection({super.key});

  @override
  State<BrandFooterSection> createState() => _BrandFooterSectionState();
}

class _BrandFooterSectionState extends State<BrandFooterSection>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _lineWidth;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    /// Smooth cinematic animations
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(curve: Curves.easeOutExpo, parent: _controller),
    );

    _lineWidth = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(curve: Curves.easeOutCubic, parent: _controller),
    );

    _glowOpacity = Tween<double>(begin: 0, end: 0.45).animate(
      CurvedAnimation(curve: Curves.easeInOut, parent: _controller),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// 🟣 Ambient Glass Glow Circle (No shimmer, no Lottie)
          AnimatedBuilder(
            animation: _glowOpacity,
            builder: (_, __) {
              return Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(_glowOpacity.value * 0.08),
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(),
                  ),
                ),
              );
            },
          ),

          /// 🌟 Logo Reveal (Premium)
          AnimatedBuilder(
            animation: _logoScale,
            builder: (_, __) {
              return Transform.scale(
                scale: _logoScale.value,
                child: Image.asset(
                  "assets/logo/reel_on_go_logo.png",
                  height: 60,
                ),
              );
            },
          ),

          /// 🔥 Neon Orange Underline
          Positioned(
            bottom: 80,
            child: AnimatedBuilder(
              animation: _lineWidth,
              builder: (_, __) {
                return Container(
                  height: 3,
                  width: _lineWidth.value,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5E1F),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFF5E1F),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// 📝 Taglines
          Positioned(
            bottom: 40,
            child: Column(
              children: const [
                Text(
                  "Fast. Creative. Unmatched.",
                  style: TextStyle(
                    color: Color(0xFFFF5E1F),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "ReelOnGo — Creating Vibes, Not Just Reels.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
