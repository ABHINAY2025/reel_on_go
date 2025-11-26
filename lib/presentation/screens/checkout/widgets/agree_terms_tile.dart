import 'package:flutter/material.dart';

class AgreeTermsTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AgreeTermsTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            if (!value) {
              bool accepted = await showExtraChargesDialog(context);

              if (accepted) {
                onChanged(true); // Only check if user pressed "I Understand"
              } else {
                onChanged(false); // Keep unchecked on close
              }
            } else {
              onChanged(false); // Uncheck normally
            }
          },
          child: Checkbox(
            value: value,
            onChanged: (v) async {
              if (v == true) {
                bool accepted = await showExtraChargesDialog(context);

                if (accepted) {
                  onChanged(true);
                } else {
                  onChanged(false);
                }
              } else {
                onChanged(false);
              }
            },
            activeColor: const Color(0xFFFF5E1F), // ORANGE CHECK
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
        ),

        const Expanded(
          child: Text.rich(
            TextSpan(
              text: "I agree to the ",
              style: TextStyle(color: Colors.white70),
              children: [
                TextSpan(
                  text: "Terms & Conditions",
                  style: TextStyle(color: Color(0xFFFF5E1F)),
                ),
                TextSpan(text: " of the cancellation policy."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// POPUP THAT RETURNS TRUE (OK) or FALSE (CLOSE)
/// ------------------------------------------------------------
Future<bool> showExtraChargesDialog(BuildContext context) async {
  bool accepted = false;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CLOSE BUTTON
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    accepted = false;  // user rejected
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: Colors.red, size: 24),
                ),
              ),

              // ICON
              const Icon(
                Icons.currency_rupee_rounded,
                color: Color(0xFFFF5E1F),
                size: 50,
              ),

              const SizedBox(height: 12),

              // TITLE
              const Text(
                "Extra Charges",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              // BULLETS
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ", style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          "Extra charges of ₹2000/hour for extended shoot time",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ", style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          "Charges to be paid after the shoot",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xFFFF5E1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    accepted = true; // user understood
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "I Understand",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return accepted;
}
