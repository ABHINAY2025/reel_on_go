import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';
import 'reels_vertical_player.dart';
import 'package:reel_on_go/presentation/widgets/bottom_nav.dart';

class ExploreScreen extends StatefulWidget {
  final String phone;

  const ExploreScreen({super.key, required this.phone});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> categories = [
    "Models",
    "Celebrities",
    "Housewarming",
    "Weddings",
    "Birthdays",
    "Baby Shower",
    "Pre-Wedding",
    "Kids Shoot",
  ];

  int selectedCategory = 0;
  int navIndex = 2;

  /// VIDEOS FROM ASSETS (MOBILE)
  final List<String> videoAssets = [
    "assets/videos/intro1.mp4",
    "assets/videos/intro2.mp4",
    "assets/videos/intro3.mp4",
  ];

  final List<VideoPlayerController> controllers = [];

  @override
  void initState() {
    super.initState();

    /// Initialize preview videos (MOBILE)
    for (var path in videoAssets) {
      final c = VideoPlayerController.asset(path);

      c.initialize().then((_) {
        setState(() {});
        c.setLooping(true);
        c.setVolume(0);
        c.play();
      });

      controllers.add(c);
    }
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
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                /// HEADER
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "What do you want to make special today?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                /// CATEGORY CHIPS
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        bool selected = selectedCategory == i;

                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: selected
                                  ? const Color(0xFFFF5E1F)
                                  : Colors.grey.shade800,
                            ),
                            child: Text(
                              categories[i],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                /// VIDEO GRID
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childCount: videoAssets.length,
                    itemBuilder: (context, index) {
                      final controller = controllers[index];

                      return GestureDetector(
                        onTap: () async {
                          /// Stop preview
                          controller.pause();

                          /// OPEN FULL SCREEN
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReelsVerticalPlayer(
                                videos: videoAssets,
                                initialIndex: index,
                                isAsset: true,   // IMPORTANT
                              ),
                            ),
                          );

                          /// Resume preview
                          controller.play();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                )
                              : Container(
                                  height: 200,
                                  color: Colors.grey.shade800,
                                ),
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 160)),
              ],
            ),

            /// BOTTOM NAV
            BottomNav(
              current: navIndex,
              onTap: (i) {
                setState(() => navIndex = i);

                if (i == 1) {
                  Navigator.pushReplacementNamed(context, "/home",
                      arguments: widget.phone);
                } else if (i == 2) {
                  // Already here
                } else if (i == 3) {
                  Navigator.pushReplacementNamed(context, "/profile",
                      arguments: widget.phone);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
