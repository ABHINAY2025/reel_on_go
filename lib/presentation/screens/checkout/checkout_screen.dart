// 📌 checkout_screen.dart (FINAL UPDATED FOR PHONE PASSING)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'widgets/user_header.dart';
import 'widgets/location_card.dart';
import 'widgets/plan_summary_card.dart';
import 'widgets/female_option_tile.dart';
import 'widgets/extra_hours_counter.dart';
import 'widgets/addons_section.dart';
import 'widgets/marketing_toggle.dart';
import 'widgets/agree_terms_tile.dart';
import 'widgets/price_summary.dart';
import 'widgets/submit_button.dart';
import 'widgets/suggest_song_field.dart';
import 'widgets/shoot_mode_selector.dart';
import 'widgets/shoot_requirements_field.dart';
import '../../bookings/book_now_screen.dart';

import 'confirm_address_screen.dart';
import 'helpers/price_utils.dart';
import 'helpers/location_service.dart';

const Color kPrimaryOrange = Color(0xFFFF5E1F);

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> plan;
  final String phone;   // 🔥 REQUIRED PHONE

  const CheckoutScreen({
    super.key,
    required this.plan,
    required this.phone,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? firstName;
  String? lastName;
  String? gender;
  bool userLoaded = false;

  String? detectedAddress;
  Position? currentPosition;
  bool locating = false;

  int extraHours = 0;
  bool marketingToggle = false;
  bool agreed = false;
  bool loading = false;

  bool addonExtraReel = false;
  bool addonCustomizedEdit = false;
  bool addonHandLight = false;

  bool addressConfirmed = false;
  Map<String, dynamic>? selectedAddress;

  final TextEditingController songController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  String shootMode = "Outdoor";

  final int extraHourPrice = 500;
  final int addonExtraReelPrice = 999;
  final int addonCustomizedEditPrice = 499;
  final int addonHandLightPrice = 499;
  final double gstRate = 0.18;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    Future.microtask(() => _ensureLocationDetectedOnce());
  }

  /// 🔥 LOAD USER NAME + GENDER USING PHONE (NO UID)
  Future<void> _loadUserName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.phone)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        firstName = data["firstName"] ?? "";
        lastName = data["lastName"] ?? "";
        gender = data["gender"] ?? "";
      }

      userLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("User load error: $e");
      userLoaded = true;
      setState(() {});
    }
  }

  Future<void> _ensureLocationDetectedOnce() async {
    if (detectedAddress == null) {
      await _detectLocation();
    }
  }

  Future<void> _detectLocation() async {
    setState(() => locating = true);

    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos == null) {
        showTopNotification("Enable location services & grant permission");
        setState(() => locating = false);
        return;
      }

      currentPosition = pos;
      detectedAddress = await LocationService.getAddressFromPosition(pos);

      setState(() => locating = false);
    } catch (e) {
      debugPrint("Location error: $e");
      showTopNotification("Failed to detect location");
      setState(() => locating = false);
    }
  }

  int _parsePrice(String price) => parsePriceToInt(price);

  double get subtotal {
    final base = _parsePrice(widget.plan['price'] ?? "₹0");
    final extras = extraHours * extraHourPrice;
    final addons = (addonExtraReel ? addonExtraReelPrice : 0) +
        (addonCustomizedEdit ? addonCustomizedEditPrice : 0) +
        (addonHandLight ? addonHandLightPrice : 0);

    return (base + extras + addons).toDouble();
  }

  double get tax => subtotal * gstRate;
  double get total => subtotal + tax;

  /// 🔥 CREATE BOOKING (phone passed directly)
  Future<void> _createBooking() async {
    if (!agreed) {
      showTopNotification("Please accept the terms & conditions.");
      return;
    }
    if (requirementsController.text.trim().isEmpty) {
      showTopNotification("Shoot requirements cannot be empty!");
      return;
    }
    if (!addressConfirmed || selectedAddress == null) {
      showTopNotification("Please add your location details first.");
      return;
    }

    setState(() => loading = true);

    final cleanPhone = widget.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final bookingId = "${cleanPhone}_${DateTime.now().millisecondsSinceEpoch}";

    final booking = {
      "bookingId": bookingId,
      "userId": cleanPhone, // 🔥 backend uses this
      "userName": "${firstName ?? ''} ${lastName ?? ''}".trim(),
      "userGender": gender ?? "",
      "plan": widget.plan,
      "extraHours": extraHours,
      "preferredSong": songController.text.trim(),
      "shootMode": shootMode,
      "shootRequirements": requirementsController.text.trim(),
      "addonExtraReel": addonExtraReel,
      "addonCustomizedEdit": addonCustomizedEdit,
      "addonHandLight": addonHandLight,
      "subtotal": subtotal,
      "tax": tax,
      "total": total,
      "marketingConsent": marketingToggle,
      "detectedAddress": detectedAddress,
      "address": selectedAddress,
      "location": currentPosition == null
          ? null
          : {
              "lat": currentPosition!.latitude,
              "lng": currentPosition!.longitude,
            },
      "createdAt": DateTime.now().toIso8601String(),
      "status": "pending",
    };

    try {
      final url = Uri.parse("http://10.20.0.4:5008/api/bookings/create");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(booking),
      );

      setState(() => loading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showTopNotification("Booking created successfully!");
        Navigator.pop(context);
      } else {
        debugPrint("Backend Error: ${response.body}");
        showTopNotification("Failed to create booking");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      showTopNotification("Network error");
      setState(() => loading = false);
    }
  }

  void showTopNotification(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 6)
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2))
        .then((_) => entry.remove());
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Checkout Summary"),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              UserHeader(
                firstName: firstName,
                phone: widget.phone,
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 18),

              LocationCard(
                detectedAddress: detectedAddress,
                locating: locating,
                onDetect: _detectLocation,
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 18),

              PlanSummaryCard(
                plan: plan,
                onChange: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookNowScreen(phone: widget.phone),
                        ),
                        (route) => route.isFirst,   // keep only first screen in stack
                      );
                    },
              color: kPrimaryOrange,
              ),
              const SizedBox(height: 18),

              FemaleOptionTile(
                gender: gender,
                onToggle: (v) => setState(() => marketingToggle = v),
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 12),

              ExtraHoursCounter(
                value: extraHours,
                onInc: () => setState(() => extraHours++),
                onDec: () => setState(
                    () => extraHours = extraHours > 0 ? extraHours - 1 : 0),
              ),
              const SizedBox(height: 14),

              AddonsSection(
                addonExtraReel: addonExtraReel,
                addonCustomizedEdit: addonCustomizedEdit,
                addonHandLight: addonHandLight,
                onToggleExtraReel: (v) =>
                    setState(() => addonExtraReel = v),
                onToggleCustomized: (v) =>
                    setState(() => addonCustomizedEdit = v),
                onToggleHandLight: (v) =>
                    setState(() => addonHandLight = v),
                color: kPrimaryOrange,
                extraReelPrice: addonExtraReelPrice,
                customizedPrice: addonCustomizedEditPrice,
                handLightPrice: addonHandLightPrice,
              ),

              SuggestSongField(controller: songController),
              const SizedBox(height: 18),

              ShootModeSelector(
                selected: shootMode,
                onChanged: (m) => setState(() => shootMode = m),
              ),
              const SizedBox(height: 18),

              ShootRequirementsField(controller: requirementsController),
              const SizedBox(height: 18),

              MarketingToggle(
                value: marketingToggle,
                onChanged: (v) => setState(() => marketingToggle = v),
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 18),

              AgreeTermsTile(
                value: agreed,
                onChanged: (v) => setState(() => agreed = v),
              ),
              const SizedBox(height: 14),

              PriceSummary(
                  subtotal: subtotal, tax: tax, total: total),
              const SizedBox(height: 18),

              SubmitButton(
                loading: loading,
                label: addressConfirmed
                    ? "Proceed to Payment"
                    : "Add Location Details",
                color: kPrimaryOrange,
                onPressed: () async {
                  if (requirementsController.text.trim().isEmpty) {
                    showTopNotification("Please fill the details");
                    return;
                  }

                  if (!agreed) {
                    showTopNotification("Please accept all details");
                    return;
                  }

                  if (!addressConfirmed) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ConfirmAddressScreen(phone: widget.phone),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        addressConfirmed = true;
                        selectedAddress = result;
                      });
                    }
                  } else {
                    _createBooking();
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),

          if (loading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: kPrimaryOrange),
              ),
            ),
        ],
      ),
    );
  }
}
