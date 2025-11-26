import 'package:flutter/material.dart';

class ShootRequirementsField extends StatelessWidget {
  final TextEditingController controller;

  const ShootRequirementsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryOrange = Color(0xFFFF5E1F);

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
            "Tell Us Your Shoot Requirements",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: controller,
            maxLines: 5,
            cursorColor: const Color.fromARGB(255, 255, 103, 21), // ✅ White blinking cursor
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              hintText:
                  "Describe how you want the reel:\n• Mood\n• Style\n• Poses\n• Location ideas\n• Transitions\n• References",
              hintStyle: const TextStyle(color: Colors.white38),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color.fromARGB(217, 66, 66, 66),
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 88, 87, 87), // 🔶 Correct orange border
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
