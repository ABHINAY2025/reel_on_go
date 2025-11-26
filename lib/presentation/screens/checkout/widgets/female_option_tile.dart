// lib/presentation/screens/checkout/widgets/female_option_tile.dart
import 'package:flutter/material.dart';

class FemaleOptionTile extends StatelessWidget {
  final String? gender;
  final ValueChanged<bool> onToggle;
  final Color color;

  const FemaleOptionTile({super.key, required this.gender, required this.onToggle, required this.color});

  @override
  Widget build(BuildContext context) {
    if (gender?.toLowerCase() == 'female') {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Opt for a Female Reel-Maker", style: TextStyle(color: Colors.white, fontSize: 15)),
              SizedBox(height: 6),
              Text("Based on your requirement", style: TextStyle(color: Colors.white54, fontSize: 12)),
            ])),
            Switch(value: false, activeColor: Colors.white, activeTrackColor: color, onChanged: onToggle),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Opt for a Female Reel-Maker", style: TextStyle(color: Colors.white, fontSize: 15)),
              SizedBox(height: 6),
              Text("Available only for female users", style: TextStyle(color: Colors.white54, fontSize: 12)),
            ])),
            IconButton(icon: const Icon(Icons.info_outline, color: Colors.white70), onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This option is available only for users with gender set to Female.")));
            }),
          ],
        ),
      );
    }
  }
}
