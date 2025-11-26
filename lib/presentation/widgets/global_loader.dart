import 'package:flutter/material.dart';

class GlobalLoader extends StatelessWidget {
  final bool isLoading;

  const GlobalLoader({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      children: [
        // Dark transparent background
        Container(
          color: Colors.black.withOpacity(0.5),
        ),

        // Center white loader
        const Center(
          child: SizedBox(
            height: 55,
            width: 55,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4,
            ),
          ),
        ),
      ],
    );
  }
}
