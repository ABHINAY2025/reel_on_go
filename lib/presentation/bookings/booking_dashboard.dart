import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reel_on_go/presentation/bookings/book_now_screen.dart';

class BookingDashboard extends StatelessWidget {
  final String username;
  final String phone;   // 🔥 REQUIRED

  const BookingDashboard({
    super.key,
    required this.username,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Greeting
        Text(
          "Hi, $username 👋",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "I'm ready when you are!",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 25,
          ),
        ),

        const SizedBox(height: 30),

        /// Menu buttons row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// BOOK NOW
              _buildIconButton(
                title: "Book Now",
                icon: Icons.add_rounded,
                color: const Color(0xFFFF5E1F),
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookNowScreen(phone: phone),
                  ),
                );
                },
              ),

              /// MY BOOKINGS
              _buildIconButton(
                title: "My Bookings",
                icon: Icons.notes_rounded,
                color: Colors.white70,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/myBookings",
                    arguments: phone,   // 🔥 PHONE PASSED
                  );
                },
              ),

              /// SCHEDULE
              _buildIconButton(
                title: "Schedule",
                icon: Icons.calendar_month_rounded,
                color: Colors.white70,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/schedule",
                    arguments: phone,   // 🔥 PHONE PASSED
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Reusable Icon Button
  Widget _buildIconButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
