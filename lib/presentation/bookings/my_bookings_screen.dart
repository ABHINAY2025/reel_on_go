// lib/presentation/bookings/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './booking_Details_Screen.dart';

class MyBookingsScreen extends StatefulWidget {
  /// Accept phone from route if passed. If null, screen will try to read
  /// phone from ModalRoute arguments inside didChangeDependencies.
  final String? phone;

  const MyBookingsScreen({super.key, this.phone});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  List<dynamic> bookings = [];
  late TabController tabController;
  late String phone;

  bool _fetchedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use phone passed to widget if provided, otherwise read from route args.
    final routePhone = ModalRoute.of(context)?.settings.arguments;
    if (widget.phone != null) {
      phone = widget.phone!;
    } else if (routePhone is String) {
      phone = routePhone;
    } else {
      // If we still don't have phone, avoid crash - set empty and show no bookings.
      phone = "";
    }

    // init tab controller once
    if (!_fetchedOnce) {
      tabController = TabController(length: 2, vsync: this);
      _fetchBookings();
      _fetchedOnce = true;
    }
  }

  Future<void> _fetchBookings() async {
    setState(() => loading = true);

    if (phone.isEmpty) {
      // No phone available — nothing to fetch
      bookings = [];
      setState(() => loading = false);
      return;
    }

    try {
      final url = Uri.parse("http://10.20.0.4:5008/api/bookings/user/$phone");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        bookings = jsonDecode(res.body);
      } else {
        // non-200 — treat as empty or handle error
        bookings = [];
      }
    } catch (e) {
      // network error -> keep bookings empty
      bookings = [];
      debugPrint("Fetch bookings error: $e");
    }

    setState(() => loading = false);
  }

  List<dynamic> get upcoming =>
      bookings.where((b) =>
          (b["status"] ?? "") == "pending" ||
          (b["status"] ?? "") == "confirmed"
      ).toList();

  List<dynamic> get completed =>
      bookings.where((b) => (b["status"] ?? "") == "completed").toList();

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchBookings,
            tooltip: "Refresh",
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Here are your bookings!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                TabBar(
                  controller: tabController,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: Colors.orange,
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BookingList(bookings: upcoming),
                      BookingList(bookings: completed),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class BookingList extends StatelessWidget {
  final List bookings;

  const BookingList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          "No bookings found",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map booking;

  const BookingCard({super.key, required this.booking});

  // Try to parse different createdAt shapes: ISO string or Firestore map
  DateTime? _parseCreatedAt(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value).toLocal();
      }

      if (value is Map && value.containsKey("_seconds")) {
        final seconds = value["_seconds"] as int;
        final nanos = (value["_nanoseconds"] ?? 0) as int;
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanos ~/ 1000000, isUtc: true).toLocal();
      }

      if (value is int) {
        // epoch ms or s — try to detect
        if (value > 9999999999) {
          // milliseconds
          return DateTime.fromMillisecondsSinceEpoch(value).toLocal();
        } else {
          // seconds
          return DateTime.fromMillisecondsSinceEpoch(value * 1000).toLocal();
        }
      }
    } catch (e) {
      debugPrint("createdAt parse error: $e");
    }

    return null;
  }

  String _formatDateTime(DateTime d) {
    final months = ["", "Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    int hr = d.hour;
    final min = d.minute.toString().padLeft(2, '0');
    final suffix = hr >= 12 ? "PM" : "AM";
    if (hr == 0) hr = 12;
    if (hr > 12) hr -= 12;
    return "${d.day.toString().padLeft(2,'0')} ${months[d.month]} ${d.year}, $hr:$min $suffix";
  }

  @override
  Widget build(BuildContext context) {
    final plan = booking["plan"] ?? {};
    final planTitle = plan["title"] ?? "Unknown Plan";

    final createdAtRaw = booking["createdAt"];
    final createdDate = _parseCreatedAt(createdAtRaw);
    final bookedOn = createdDate != null ? _formatDateTime(createdDate) : (createdAtRaw?.toString() ?? "Unknown date");

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailsScreen(booking: booking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white10,
              child: Icon(Icons.camera_alt, color: Colors.orange, size: 26),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planTitle,
                    style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Booked on: $bookedOn",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Mode: ${booking["shootMode"] ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${booking["total"] ?? booking["subtotal"] ?? '0'}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  (booking["status"] ?? "pending").toString(),
                  style: TextStyle(
                    color: booking["status"] == "completed"
                        ? Colors.green
                        : Colors.orange,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
