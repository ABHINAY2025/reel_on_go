import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map booking;

  const BookingDetailsScreen({super.key, required this.booking});

  // -------------------------------
  // 🔥 FIRESTORE TIMESTAMP PARSER
  // -------------------------------
  DateTime parseFirestoreTimestamp(dynamic ts) {
    try {
      if (ts is Map && ts.containsKey("seconds")) {
        int seconds = ts["seconds"];
        int nanos = ts["nanos"] ?? 0;
        return DateTime.fromMillisecondsSinceEpoch(
          (seconds * 1000) + (nanos ~/ 1000000),
          isUtc: true,
        ).toLocal();
      }
    } catch (e) {
      debugPrint("Timestamp parse error: $e");
    }
    return DateTime.now();
  }

  // -------------------------------
  // 📅 PRETTY DATE FORMATTER
  // -------------------------------
  String formatDate(DateTime d) {
    const months = [
      "", "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    String time =
        "${d.hour % 12 == 0 ? 12 : d.hour % 12}:${d.minute.toString().padLeft(2, "0")} ${d.hour >= 12 ? "PM" : "AM"}";

    return "${d.day} ${months[d.month]} ${d.year}, $time";
  }

  @override
  Widget build(BuildContext context) {
    final DateTime bookedDate = parseFirestoreTimestamp(booking["createdAt"]);
    final String bookedOnText = formatDate(bookedDate);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Booking Details"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // -------------------------------------------------
          // 🔥 USER GREETING
          // -------------------------------------------------
          Text(
            "Hi, ${booking["userName"] ?? "User"} 👋",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Check your booking details!",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 26),

          // -------------------------------------------------
          // 📍 ADDRESS BLOCK
          // -------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_pin, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${booking["address"]?["house"] ?? ""}, "
                  "${booking["address"]?["area"] ?? ""}, "
                  "${booking["address"]?["landmark"] ?? ""}, "
                  "${booking["address"]?["pin"] ?? ""}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Icon(Icons.person, color: Colors.orange, size: 24),
              SizedBox(width: 10),
              Text(
                "Partner: NA",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "Booked on $bookedOnText",
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),

          const SizedBox(height: 35),

          // -------------------------------------------------
          // 📸 SHOOT DETAILS
          // -------------------------------------------------
          const Text(
            "Shoot Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          buildDetailRow("Category", booking["plan"]?["title"] ?? "N/A"),
          buildDetailRow("Price", "₹${booking["total"] ?? 0}"),

          buildDetailRow("Shoot Mode", booking["shootMode"] ?? "N/A"),
          buildDetailRow("Extra Hours", booking["extraHours"].toString()),

          buildDetailRow("Reel Extras",
              booking["addonExtraReel"] ? "Yes" : "No"),
          buildDetailRow("Customized Edit",
              booking["addonCustomizedEdit"] ? "Yes" : "No"),
          buildDetailRow("Hand Light",
              booking["addonHandLight"] ? "Yes" : "No"),

          buildDetailRow("Requirements",
              booking["shootRequirements"] ?? "N/A"),

          const SizedBox(height: 40),

          // -------------------------------------------------
          // 🧾 BOOKING ID
          // -------------------------------------------------
          Center(
            child: Text(
              "Booking ID: ${booking["bookingId"]}",
              style: const TextStyle(color: Colors.white38),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // 🔧 REUSABLE ROW BUILDER
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          SizedBox(
            width: 180,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
