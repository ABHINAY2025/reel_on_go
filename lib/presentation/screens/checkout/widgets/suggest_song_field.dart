import 'package:flutter/material.dart';

class SuggestSongField extends StatelessWidget {
  final TextEditingController controller;

  const SuggestSongField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Suggest a Song",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: controller,
            cursorColor: Colors.white, // ✅ White blinking cursor
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              hintText: "Enter your preferred reel song",
              hintStyle: const TextStyle(color: Colors.white38),

              // 🔹 Border when NOT focused
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.white24,
                  width: 1,
                ),
              ),

              // 🔹 Border when focused (GRAY as requested)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 90, 90, 90), // gray
                  width: 2,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
