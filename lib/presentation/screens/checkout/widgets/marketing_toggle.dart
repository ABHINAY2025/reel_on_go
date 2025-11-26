// lib/presentation/screens/checkout/widgets/marketing_toggle.dart
import 'package:flutter/material.dart';

class MarketingToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  const MarketingToggle({super.key, required this.value, required this.onChanged, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text("Use this Reel for marketing", style: TextStyle(color: Colors.white))),
          Switch(value: value, activeColor: Colors.white, activeTrackColor: color, onChanged: onChanged),
        ],
      ),
    );
  }
}
