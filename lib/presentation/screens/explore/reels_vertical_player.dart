import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../bookings/book_now_screen.dart';

class ReelsVerticalPlayer extends StatefulWidget {
  final List<String> videos;
  final int initialIndex;
  final bool isAsset;
  final String? phone;

  const ReelsVerticalPlayer({
    super.key,
    required this.videos,
    this.initialIndex = 0,
    this.isAsset = true,
    this.phone,
  });

  @override
  State<ReelsVerticalPlayer> createState() => _ReelsVerticalPlayerState();
}

class _ReelsVerticalPlayerState extends State<ReelsVerticalPlayer>
    with TickerProviderStateMixin {
  late PageController pageController;
  final List<VideoPlayerController> controllers = [];
  int currentIndex = 0;

  // GLOBAL MUTE — applies to all videos
  static bool isMuted = false;

  // Like animation
  bool showHeart = false;
  late AnimationController heartAnim;
  late Animation<double> heartScale;

  // Mute animation
  bool showMuteAnim = false;
  late AnimationController muteAnim;
  late Animation<double> muteFade;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    /// immersive
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;

    /// ❤️ LIKE animation
    heartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    heartScale = Tween<double>(begin: 0.4, end: 1.5).animate(
      CurvedAnimation(parent: heartAnim, curve: Curves.easeOut),
    );

    /// 🔇 MUTE animation
    muteAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    muteFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: muteAnim, curve: Curves.easeOut),
    );

    /// Load all videos
    for (var path in widget.videos) {
      final controller = widget.isAsset
          ? VideoPlayerController.asset(path)
          : VideoPlayerController.network(path);

      controller.initialize().then((_) => setState(() {}));
      controller.setLooping(true);
      controller.setVolume(isMuted ? 0 : 1);
      controllers.add(controller);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllers[currentIndex].play();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    heartAnim.dispose();
    muteAnim.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void onPageChanged(int index) {
    controllers[currentIndex].pause();

    setState(() => currentIndex = index);

    controllers[index].setVolume(isMuted ? 0 : 1);
    controllers[index].play();
  }

  /// 🔇 SINGLE TAP → MUTE
  void toggleMute() {
    setState(() {
      isMuted = !isMuted;

      for (var c in controllers) {
        c.setVolume(isMuted ? 0 : 1);
      }

      showMuteAnim = true;
      muteAnim.forward(from: 0).then((_) {
        setState(() => showMuteAnim = false);
      });
    });
  }

  /// ❤️ DOUBLE TAP → LIKE
  void triggerLike() {
    setState(() {
      isLiked = true;
      showHeart = true;

      heartAnim.forward(from: 0).then((_) {
        setState(() => showHeart = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: onPageChanged,
        itemCount: widget.videos.length,
        itemBuilder: (_, index) {
          final controller = controllers[index];

          return Stack(
            children: [
              /// 🎥 VIDEO PLAYER
              controller.value.isInitialized
                  ? GestureDetector(
                      onTap: toggleMute,
                      onDoubleTap: triggerLike,
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller.value.size.width,
                            height: controller.value.size.height,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),

              /// ❤️ HEART ANIMATION
              if (showHeart)
                Center(
                  child: ScaleTransition(
                    scale: heartScale,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),

              /// 🔇 MUTE INDICATOR
              if (showMuteAnim)
                Center(
                  child: FadeTransition(
                    opacity: muteFade,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),

              /// 📌 CREATOR + CAPTION
              Positioned(
                left: 16,
                bottom: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "@creator_name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      width: 260,
                      child: Text(
                        "Beautiful moments captured in cinematic style ❤️✨",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ❤️ LIKE / 💬 COMMENT / 🔗 SHARE
              Positioned(
                right: 16,
                bottom: 130,
                child: Column(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      size: 34,
                    ),
                    const SizedBox(height: 16),

                    const Icon(Icons.comment, size: 32, color: Colors.white),
                    const SizedBox(height: 16),

                    const Icon(Icons.share, size: 30, color: Colors.white),
                  ],
                ),
              ),

              /// ⭐ FULL-WIDTH ROUNDED "BOOK NOW" BUTTON (OPTION B)
              Positioned(
                left: 16,
                right: 16,
                bottom: 35,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BookNowScreen(phone: widget.phone ?? ""),
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade400,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              /// ❌ CLOSE BUTTON
              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    controllers[currentIndex].pause();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 30),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
