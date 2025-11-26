import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InvoicePdfScreen extends StatelessWidget {
  final Map<String, dynamic> invoice;

  const InvoicePdfScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Preview"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        allowPrinting: true,
        allowSharing: true,
        build: (format) => _generatePdf(),
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // HEADER
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                      pw.Text(
                        "ReelOnGo",
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                  pw.Container(
                    width: 80,
                    height: 80,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: invoice["bookingId"],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // CUSTOMER DETAILS
              pw.Text("Customer Details",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _row("Name", invoice["customer"]),
              _row("Phone", invoice["phone"]),
              _row("Address", invoice["address"]),
              _row("Date", invoice["date"]),
              pw.Divider(),

              pw.SizedBox(height: 12),

              // BOOKING DETAILS
              pw.Text("Booking Details",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _row("Booking ID", invoice["bookingId"]),
              _row("Plan", invoice["planTitle"]),
              _row("Shoot Mode", invoice["shootMode"]),
              _row("Extra Hours", "${invoice["extraHours"]} hrs"),
              _row("Addons", invoice["addons"]),
              pw.Divider(),

              pw.SizedBox(height: 12),

              // PRICE BREAKDOWN
              pw.Text("Price Summary",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              _row("Subtotal", "₹${invoice["subtotal"]}"),
              _row("GST (18%)", "₹${invoice["tax"]}"),
              pw.SizedBox(height: 4),

              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: _row(
                  "TOTAL",
                  "₹${invoice["total"]}",
                  isBold: true,
                  fontSize: 22,
                ),
              ),

              pw.SizedBox(height: 24),

              pw.Center(
                child:pw.Text(
                    "Thank you for choosing ReelOnGo!",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _row(String label, String value,
      {bool isBold = false, double fontSize = 16}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: fontSize,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: fontSize,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
