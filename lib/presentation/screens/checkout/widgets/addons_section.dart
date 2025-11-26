// lib/presentation/screens/checkout/widgets/addons_section.dart
import 'package:flutter/material.dart';

class AddonsSection extends StatelessWidget {
  final bool addonExtraReel;
  final bool addonCustomizedEdit;
  final bool addonHandLight;
  final ValueChanged<bool> onToggleExtraReel;
  final ValueChanged<bool> onToggleCustomized;
  final ValueChanged<bool> onToggleHandLight;
  final Color color;
  final int extraReelPrice;
  final int customizedPrice;
  final int handLightPrice;

  const AddonsSection({
    super.key,
    required this.addonExtraReel,
    required this.addonCustomizedEdit,
    required this.addonHandLight,
    required this.onToggleExtraReel,
    required this.onToggleCustomized,
    required this.onToggleHandLight,
    required this.color,
    required this.extraReelPrice,
    required this.customizedPrice,
    required this.handLightPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(alignment: Alignment.centerLeft, child: Text("Add On's", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        _addonTile("Extra Reel", "For One Additional Reel", "+ ₹$extraReelPrice", addonExtraReel, onToggleExtraReel, color),
        _addonTile("Customized Reel Edit", "Tweak your reel edit as you wish", "+ ₹$customizedPrice", addonCustomizedEdit, onToggleCustomized, color),
        _addonTile("Hand Light", "Based on your requirement", "+ ₹$handLightPrice", addonHandLight, onToggleHandLight, color),
      ],
    );
  }

  Widget _addonTile(String title, String subtitle, String price, bool checked, ValueChanged<bool> onChanged, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.white54)),
          ])),
          Text(price, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Checkbox(value: checked, onChanged: (v) => onChanged(v ?? false), activeColor: color, checkColor: Colors.white),
        ],
      ),
    );
  }
}
