// lib/presentation/screens/checkout/widgets/submit_button.dart
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool loading;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.loading, required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      child: loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)) : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
