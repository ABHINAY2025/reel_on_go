// lib/presentation/screens/checkout/widgets/price_summary.dart
import 'package:flutter/material.dart';

class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;

  const PriceSummary({super.key, required this.subtotal, required this.tax, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          _priceRow("Package Amount", "Rs. ${subtotal.toInt()}"),
          const SizedBox(height: 6),
          _priceRow("Tax", "Rs. ${tax.toStringAsFixed(2)}"),
          const Divider(color: Colors.white12),
          _priceRowBold("Total", "Rs. ${total.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white70)), Text(value, style: const TextStyle(color: Colors.white70))]);
  }

  Widget _priceRowBold(String title, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]);
  }
}
