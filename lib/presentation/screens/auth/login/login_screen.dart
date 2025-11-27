import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reel_on_go/core/routes/app_routes.dart';
import 'package:reel_on_go/logic/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Enter your mobile number to continue",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              /// PHONE INPUT
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E1F),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    String phone = phoneController.text.trim();

                    if (phone.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid phone number"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    // 🔥 Clean number to ensure only digits
                    String clean = phone.replaceAll(RegExp(r'[^0-9]'), '');

                    // Call AuthController
                    String result = await auth.loginUser(clean);

                    if (result == "existing") {
                      // Login → Go Home
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                        arguments: clean,
                      );
                    } else if (result == "new") {
                      // New user → Location setup
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.location,
                        arguments: clean,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Something went wrong"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: auth.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Continue",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
