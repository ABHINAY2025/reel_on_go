// 📌 schedule_checkout.dart
// Same as checkout_screen.dart BUT includes schedule date + start time picker

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../checkout/widgets/user_header.dart';
import '../../checkout/widgets/location_card.dart';
import '../../checkout/widgets/plan_summary_card.dart';
import '../../checkout/widgets/female_option_tile.dart';
import '../../checkout/widgets/extra_hours_counter.dart';
import '../../checkout/widgets/addons_section.dart';
import '../../checkout/widgets/marketing_toggle.dart';
import '../../checkout/widgets/agree_terms_tile.dart';
import '../../checkout/widgets/price_summary.dart';
import '../../checkout/widgets/submit_button.dart';
import '../../checkout/widgets/suggest_song_field.dart';
import '../../checkout/widgets/shoot_mode_selector.dart';
import '../../checkout/widgets/shoot_requirements_field.dart';

import '../confirm_address_screen.dart';
import '../helpers/price_utils.dart';
import '../helpers/location_service.dart';

const Color kPrimaryOrange = Color(0xFFFF5E1F);

class ScheduleCheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> plan;
  final String phone;

  const ScheduleCheckoutScreen({
    super.key,
    required this.plan,
    required this.phone,
  });

  @override
  State<ScheduleCheckoutScreen> createState() => _ScheduleCheckoutScreenState();
}

class _ScheduleCheckoutScreenState extends State<ScheduleCheckoutScreen> {
  String? firstName;
  String? lastName;
  String? gender;

  bool userLoaded = false;

  // LOCATION
  String? detectedAddress;
  Position? currentPosition;
  bool locating = false;

  // BOOKING DATA
  int extraHours = 0;
  bool addonExtraReel = false;
  bool addonCustomizedEdit = false;
  bool addonHandLight = false;

  bool marketingToggle = false;
  bool agreed = false;
  bool loading = false;

  bool addressConfirmed = false;
  Map<String, dynamic>? selectedAddress;

  final TextEditingController songController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  String shootMode = "Outdoor";

  final double gstRate = 0.18;

  /// NEW: Scheduled date + time
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    Future.microtask(() => _ensureLocation());
  }

  Future<void> _loadUserName() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.phone)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        firstName = data["firstName"];
        lastName = data["lastName"];
        gender = data["gender"];
      }

      setState(() => userLoaded = true);
    } catch (e) {
      setState(() => userLoaded = true);
      
    }
  }

  Future<void> _ensureLocation() async {
    if (detectedAddress == null) await _detectLocation();
  }

  Future<void> _detectLocation() async {
    setState(() => locating = true);

    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos == null) {
        showTopNotification("Enable location services");
        setState(() => locating = false);
        return;
      }

      currentPosition = pos;
      detectedAddress = await LocationService.getAddressFromPosition(pos);
      setState(() => locating = false);
    } catch (_) {
      setState(() => locating = false);
    }
  }

  // PRICE
  int _parse(String price) => parsePriceToInt(price);

  double get subtotal {
    final base = _parse(widget.plan['price']);
    final addons =
        (addonExtraReel ? 999 : 0) +
        (addonCustomizedEdit ? 499 : 0) +
        (addonHandLight ? 499 : 0);

    final extra = extraHours * 500;

    return (base + addons + extra).toDouble();
  }

  double get tax => subtotal * gstRate;
  double get total => subtotal + tax;

  /// *******************************
  /// CREATE SCHEDULE BOOKING
  /// *******************************
  Future<void> _createScheduledBooking() async {
    if (selectedDate == null) {
      showTopNotification("Please select date");
      return;
    }
    if (selectedStartTime == null) {
      showTopNotification("Please select start time");
      return;
    }
    if (!agreed) {
      showTopNotification("Accept the terms");
      return;
    }
    if (!addressConfirmed) {
      showTopNotification("Add your location");
      return;
    }

    setState(() => loading = true);

    final cleanPhone = widget.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final bookingId = "${cleanPhone}_${DateTime.now().millisecondsSinceEpoch}";

    // Combine date + time
    final scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedStartTime!.hour,
      selectedStartTime!.minute,
    );

    final booking = {
      "bookingId": bookingId,
      "userId": cleanPhone,
      "userName": "${firstName ?? ''} ${lastName ?? ''}",
      "userGender": gender,
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

      // THE NEW FIELDS
      "scheduledDate": selectedDate!.toIso8601String(),
      "scheduledTime": selectedStartTime!.format(context),
      "scheduledTimestamp": scheduledDateTime.toIso8601String(),

      "createdAt": DateTime.now().toIso8601String(),
      "status": "scheduled",
    };

    try {
      final url = Uri.parse("http://10.20.0.4:5008/api/schedule/create");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(booking),
      );

      setState(() => loading = false);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showTopNotification("Shoot Scheduled!");
        Navigator.pop(context);
      } else {
        showTopNotification("Failed! Try again");
      }
    } catch (e) {
      showTopNotification("Network error");
      setState(() => loading = false);
    }
  }

  void showTopNotification(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // *******************************
  // PICK DATE
  // *******************************
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kPrimaryOrange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => selectedDate = picked);
  }

  // *******************************
  // PICK TIME
  // *******************************
  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: kPrimaryOrange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => selectedStartTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Schedule Checkout"),
        backgroundColor: Colors.black,
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
              const SizedBox(height: 20),

              /// -------------------------
              /// DATE PICKER BOX
              /// -------------------------
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kPrimaryOrange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: kPrimaryOrange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? "Select Shoot Date"
                              : DateFormat("dd MMM yyyy").format(selectedDate!),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// -------------------------
              /// START TIME PICKER BOX
              /// -------------------------
              GestureDetector(
                onTap: pickTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kPrimaryOrange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: kPrimaryOrange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedStartTime == null
                              ? "Select Start Time"
                              : selectedStartTime!.format(context),
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // LOCATION
              LocationCard(
                detectedAddress: detectedAddress,
                locating: locating,
                onDetect: _detectLocation,
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 24),

              // PLAN SUMMARY
              PlanSummaryCard(
                plan: plan,
                onChange: () => Navigator.pop(context),
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 24),

              // FEMALE OPTION
              FemaleOptionTile(
                gender: gender,
                onToggle: (v) => setState(() => marketingToggle = v),
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 20),

              ExtraHoursCounter(
                value: extraHours,
                onInc: () => setState(() => extraHours++),
                onDec: () => setState(() {
                  if (extraHours > 0) extraHours--;
                }),
              ),
              const SizedBox(height: 20),

              AddonsSection(
                addonExtraReel: addonExtraReel,
                addonCustomizedEdit: addonCustomizedEdit,
                addonHandLight: addonHandLight,
                onToggleExtraReel: (v) => setState(() => addonExtraReel = v),
                onToggleCustomized: (v) =>
                    setState(() => addonCustomizedEdit = v),
                onToggleHandLight: (v) => setState(() => addonHandLight = v),
                color: kPrimaryOrange,
                extraReelPrice: 999,
                customizedPrice: 499,
                handLightPrice: 499,
              ),
              const SizedBox(height: 20),

              SuggestSongField(controller: songController),
              const SizedBox(height: 20),

              ShootModeSelector(
                selected: shootMode,
                onChanged: (m) => setState(() => shootMode = m),
              ),
              const SizedBox(height: 20),

              ShootRequirementsField(controller: requirementsController),
              const SizedBox(height: 20),

              MarketingToggle(
                value: marketingToggle,
                onChanged: (v) => setState(() => marketingToggle = v),
                color: kPrimaryOrange,
              ),
              const SizedBox(height: 20),

              AgreeTermsTile(
                value: agreed,
                onChanged: (v) => setState(() => agreed = v),
              ),
              const SizedBox(height: 20),

              PriceSummary(subtotal: subtotal, tax: tax, total: total),
              const SizedBox(height: 24),

              SubmitButton(
                loading: loading,
                label: addressConfirmed ? "Confirm Schedule" : "Add Location Details",
                color: kPrimaryOrange,
                onPressed: () async {
                  if (!addressConfirmed) {
                    // Open Confirm Address Screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmAddressScreen(phone: widget.phone),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        selectedAddress = result;
                        addressConfirmed = true;
                      });
                    }
                    return;
                  }

                  // If address is confirmed → create schedule booking
                  _createScheduledBooking();
                },
              ),

              const SizedBox(height: 40),
            ],
          ),

          if (loading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(color: kPrimaryOrange),
              ),
            ),
        ],
      ),
    );
  }
}
