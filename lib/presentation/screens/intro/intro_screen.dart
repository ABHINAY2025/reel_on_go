import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:reel_on_go/core/routes/app_routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? autoSwipeTimer;

  final List<Map<String, String>> introData = [
    {
      "title": "Book Professional Reel Makers",
      "subtitle": "Instantly connect with top creators near you.",
      "video": "assets/videos/intro1.mp4",
    },
    {
      "title": "Cinematic Visuals Delivered Fast",
      "subtitle": "High-quality reels with quick turnaround.",
      "video": "assets/videos/intro2.mp4",
    },
    {
      "title": "Zero Hassle. Full Creativity.",
      "subtitle": "We manage the workflow. You enjoy the results.",
      "video": "assets/videos/intro3.mp4",
    },
  ];

  late List<VideoPlayerController> controllers;

  @override
void initState() {
  super.initState();

  controllers = [];

  for (var item in introData) {
    VideoPlayerController vc = VideoPlayerController.asset(item["video"]!);

    vc.initialize().then((_) {
      vc.setVolume(0);
      vc.setLooping(true);
      vc.play();

      if (mounted) {
        setState(() {});
      }
    });

    controllers.add(vc);
  }

  /// Auto swipe every 10 seconds
  autoSwipeTimer = Timer.periodic(const Duration(seconds: 10), (_) {
    if (_currentIndex < introData.length - 1) {
      _controller.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      _controller.animateToPage(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  });
}


  @override
  void dispose() {
    autoSwipeTimer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// FULLSCREEN VIDEO CAROUSEL
          PageView.builder(
            controller: _controller,
            itemCount: introData.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);

              // Pause all videos
              for (var c in controllers) {
                if (c.value.isInitialized) c.pause();
              }

              // Play currently selected video
              final current = controllers[index];
              if (current.value.isInitialized) {
                current.setLooping(true);
                current.setVolume(0);
                current.play();
              }
            },
            itemBuilder: (context, index) {
              final videoController = controllers[index];

              return Stack(
                children: [
                  /// FULLSCREEN VIDEO
                  Positioned.fill(
                    child: videoController.value.isInitialized
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: videoController.value.size.width,
                              height: videoController.value.size.height,
                              child: VideoPlayer(videoController),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF5E1F),
                            ),
                          ),
                  ),

                  /// BOTTOM BLACK FADE
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: size.height * 0.47,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),

                  /// TEXT
                  Positioned(
                    bottom: size.height * 0.20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          introData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          introData[index]['subtitle']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          /// INDICATORS + LOGIN BUTTON
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                /// DOT INDICATORS
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      introData.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? const Color(0xFFFF5E1F)
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E1F),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
