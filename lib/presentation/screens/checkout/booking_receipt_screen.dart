import 'package:flutter/material.dart';

class BookingReceiptScreen extends StatelessWidget {
  final String bookingId;
  final String planTitle;
  final double amountPaid;
  final String userName;
  final String userPhone;
  final String date;
  final String address;

  const BookingReceiptScreen({
    super.key,
    required this.bookingId,
    required this.planTitle,
    required this.amountPaid,
    required this.userName,
    required this.userPhone,
    required this.date,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Booking Receipt"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "ReelOnGo",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF5E1F),
                          ),
                        ),
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 36,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // BOOKING DETAILS
                    _row("Booking ID", bookingId),
                    _row("Customer", userName),
                    _row("Phone", userPhone),
                    _row("Plan", planTitle),
                    _row("Address", address),
                    _row("Booking Date", date),

                    const Divider(height: 30, thickness: 1),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Amount Paid",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹${amountPaid.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Download PDF Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E1F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/downloadInvoice", arguments: {
                    "bookingId": bookingId,
                    "planTitle": planTitle,
                    "amount": amountPaid,
                    "customer": userName,
                    "phone": userPhone,
                    "date": date,
                    "address": address,
                  });
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text(
                  "Download Invoice",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 180,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
