import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';  // Optional if using Lottie
// import 'package:get/get.dart';       // Optional if using navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // your logo animation length
    );

    // Start animation
    _controller.forward();

    // Navigate after animation completes
    Future.delayed(const Duration(seconds: 3), () {
      // Check if user logged in → direct to home
      // else → go to intro screen
      Navigator.pushReplacementNamed(context, '/intro');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,

          // ⭐ Replace this with your REAL animation later
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _controller.value,
                child: Transform.scale(
                  scale: 0.8 + (_controller.value * 0.2),
                  child: Image.asset(
                    'assets/logo/reel_on_go_logo.png', // update path
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
