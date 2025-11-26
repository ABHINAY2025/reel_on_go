// lib/presentation/screens/checkout/widgets/extra_hours_counter.dart
import 'package:flutter/material.dart';

class ExtraHoursCounter extends StatelessWidget {
  final int value;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const ExtraHoursCounter({super.key, required this.value, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text("Choose number of extra hours", style: TextStyle(color: Colors.white, fontSize: 15)),
          ])),
          Row(children: [
            _counterBtn("-", onDec),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text("$value", style: const TextStyle(color: Colors.white, fontSize: 16))),
            _counterBtn("+", onInc),
          ])
        ],
      ),
    );
  }

  Widget _counterBtn(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
