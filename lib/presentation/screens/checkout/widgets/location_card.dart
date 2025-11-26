// lib/presentation/screens/checkout/widgets/location_card.dart
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String? detectedAddress;
  final bool locating;
  final VoidCallback onDetect;
  final Color color;

  const LocationCard({super.key, this.detectedAddress, required this.locating, required this.onDetect, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(Icons.location_on, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(detectedAddress ?? "No location detected yet", style: const TextStyle(color: Colors.white70))),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: locating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.my_location),
            label: Text(locating ? "Detecting..." : (detectedAddress == null ? "Detect" : "Change")),
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: locating ? null : onDetect,
          ),
        ],
      ),
    );
  }
}
