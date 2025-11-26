import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reel_on_go/core/routes/app_routes.dart';
import 'package:reel_on_go/logic/controllers/auth_controller.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedCity;

  final List<String> cities = [
    "Hyderabad",
    "Bangalore",
    "Mumbai",
    "Chennai",
    "Delhi",
    "Pune",
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  const Text(
                    "Select Your Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Choose the city where you want services.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 35),

                  Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        String city = cities[index];

                        bool isSelected = selectedCity == city;

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedCity = city);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF5E1F)
                                    : Colors.white10,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  city,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFFF5E1F)
                                          : Colors.white38,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFFFF5E1F)
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCity != null
                            ? const Color(0xFFFF5E1F)
                            : Colors.grey.shade800,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedCity == null
                          ? null
                          : () async {
                              await auth.updateUserLocation(selectedCity!);

                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.profileSetup,
                              );
                            },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),

        // Loader overlay
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
