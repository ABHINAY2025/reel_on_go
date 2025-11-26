// lib/presentation/screens/checkout/widgets/plan_summary_card.dart
import 'package:flutter/material.dart';

class PlanSummaryCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onChange;
  final Color color;

  const PlanSummaryCard({super.key, required this.plan, required this.onChange, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (plan['tag'] != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(14)),
                  child: Text(plan['tag'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(height: 8),
              ],
              Text(plan['title'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(plan['subtitle'] ?? "", style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(plan['price'] ?? "₹0", style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Text("+GST", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ]),
            ]),
          ),
          Column(children: [
            GestureDetector(
              onTap: onChange,
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Icons.swap_horiz, color: Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            const Text("Change Plan", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ])
        ],
      ),
    );
  }
}
