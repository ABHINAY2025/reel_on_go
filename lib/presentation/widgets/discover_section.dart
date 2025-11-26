import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DiscoverSection extends StatefulWidget {
  const DiscoverSection({super.key});

  @override
  State<DiscoverSection> createState() => _DiscoverSectionState();
}

class _DiscoverSectionState extends State<DiscoverSection> {
  final List<String> videoPaths = [
    "assets/videos/intro1.mp4",
    "assets/videos/intro2.mp4",
    "assets/videos/intro3.mp4",
  ];

  late List<VideoPlayerController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = [];

    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    for (String path in videoPaths) {
      final vc = VideoPlayerController.asset(path);

      await vc.initialize();

      vc.setLooping(true);
      vc.setVolume(0);
      vc.play();

      controllers.add(vc);
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Discover with Vibe",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            Text(
              "See All",
              style: TextStyle(color: Color(0xFFFF5E1F), fontSize: 14),
            )
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 340,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controllers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final controller = controllers[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 200,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFFFF5E1F)),
                            ),

                      Positioned(
                        bottom: -6,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding:
                              const EdgeInsets.only(bottom: 20, left: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: const Text(
                            "Vibe Shoot",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
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
