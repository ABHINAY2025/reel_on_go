import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reel_on_go/core/routes/app_routes.dart';
import 'package:reel_on_go/logic/controllers/auth_controller.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String phone;

  const ProfileSetupScreen({super.key, required this.phone});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? gender;

  Future<void> pickDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF5E1F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dobController.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  Widget minimalField(String label, TextEditingController controller,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          cursorColor: const Color(0xFFFF5E1F),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF5E1F), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget genderChip(String value, IconData icon) {
    final bool selected = gender == value;

    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF5E1F) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? Colors.black : Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SAVE PROFILE
  void submit(String phone) async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        email.text.isEmpty ||
        dobController.text.isEmpty ||
        gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all details"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthController>(context, listen: false);

    final profileData = {
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "email": email.text.trim(),
      "dob": dobController.text.trim(),
      "gender": gender,
    };

    await auth.saveUserProfile(phone, profileData);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: phone,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    /// 🔥 Get phone number passed from LocationScreen
    final String phone =
        ModalRoute.of(context)!.settings.arguments as String;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Set up your profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tell us about yourself",
                    style: TextStyle(color: Colors.white60, fontSize: 15),
                  ),

                  const SizedBox(height: 35),

                  minimalField("First Name", firstName),
                  minimalField("Last Name", lastName),
                  minimalField("Email", email),
                  minimalField("Date of Birth", dobController,
                      readOnly: true, onTap: pickDOB),

                  const Text(
                    "Gender",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      genderChip("Male", Icons.male),
                      const SizedBox(width: 14),
                      genderChip("Female", Icons.female),
                    ],
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E1F),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => submit(phone),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ),

        if (auth.loading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
