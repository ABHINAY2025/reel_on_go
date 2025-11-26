// lib/presentation/screens/checkout/widgets/user_header.dart
import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String? firstName;
  final String? phone;
  final Color color;
  const UserHeader({super.key, this.firstName, this.phone, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color,
          child: Text(
            (firstName?.isNotEmpty == true ? firstName![0].toUpperCase() : "?"),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Hey, ${firstName ?? 'User'}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(phone ?? "", style: const TextStyle(color: Colors.white70)),
          ]),
        ),
      ],
    );
  }
}
