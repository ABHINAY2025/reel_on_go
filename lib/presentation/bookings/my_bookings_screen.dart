import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './booking_Details_Screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  List<dynamic> bookings = [];
  late TabController tabController;
  late String phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    phone = ModalRoute.of(context)!.settings.arguments as String;

    tabController = TabController(length: 2, vsync: this);
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final url = Uri.parse("http://10.20.0.4:5008/api/bookings/user/$phone");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      bookings = jsonDecode(res.body);
    }

    setState(() => loading = false);
  }

  List<dynamic> get upcoming => bookings
      .where((b) => b["status"] == "pending" || b["status"] == "confirmed")
      .toList();

  List<dynamic> get completed =>
      bookings.where((b) => b["status"] == "completed").toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            )
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

  /// --- SUPPORT ALL TIMESTAMP FORMATS ---
  DateTime? getCreatedAt(dynamic raw) {
    if (raw == null) return null;

    // Case 1: Firestore JSON → {_seconds, _nanoseconds}
    if (raw is Map && raw.containsKey("_seconds")) {
      return DateTime.fromMillisecondsSinceEpoch(
        raw["_seconds"] * 1000 +
            ((raw["_nanoseconds"] ?? 0) ~/ 1000000),
        isUtc: true,
      ).toLocal();
    }

    // Case 2: Sometimes Spring returns {seconds, nanoseconds}
    if (raw is Map && raw.containsKey("seconds")) {
      return DateTime.fromMillisecondsSinceEpoch(
        raw["seconds"] * 1000 +
            ((raw["nanoseconds"] ?? 0) ~/ 1000000),
        isUtc: true,
      ).toLocal();
    }

    // Case 3: ISO string
    if (raw is String) {
      try {
        return DateTime.parse(raw).toLocal();
      } catch (_) {}
    }

    return null;
  }

  String monthName(int m) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[m];
  }

  String formatFull(DateTime d) {
    int hr = d.hour;
    String suffix = hr >= 12 ? "PM" : "AM";
    if (hr == 0) hr = 12;
    if (hr > 12) hr -= 12;

    return "${d.day.toString().padLeft(2, '0')} "
        "${monthName(d.month)} "
        "${d.year} at "
        "$hr:${d.minute.toString().padLeft(2, '0')} $suffix";
  }

  @override
  Widget build(BuildContext context) {
    final plan = booking["plan"] ?? {};
    final String planTitle = plan["title"] ?? "Unknown Plan";

    final DateTime? date = getCreatedAt(booking["createdAt"]);
    final String bookedOn =
        date == null ? "Unknown date" : formatFull(date);

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
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white10,
              child:
                  const Icon(Icons.camera_alt, color: Colors.orange, size: 26),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Booked on: $bookedOn",
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Mode: ${booking["shootMode"] ?? "N/A"}",
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${booking["total"]}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  booking["status"],
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
