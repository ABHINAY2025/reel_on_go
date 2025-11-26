import 'package:flutter/material.dart';
import '../checkout/widgets/top_toast.dart';
import '../../../../logic/controllers/loader_controller.dart';

class ConfirmAddressScreen extends StatefulWidget {
  final String? phone;

  const ConfirmAddressScreen({super.key, required this.phone});

  @override
  State<ConfirmAddressScreen> createState() => _ConfirmAddressScreenState();
}

class _ConfirmAddressScreenState extends State<ConfirmAddressScreen> {
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  // CREATE LOADER INSTANCE
  final LoaderController loader = LoaderController();

  String selectedType = "Home";

  bool _validateFields() {
    return houseController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        landmarkController.text.isNotEmpty &&
        pinController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loader,
      builder: (context, _) {
        return Stack(
          children: [
            _mainUI(),

            // LOADER OVERLAY
            if (loader.loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF5E1F),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _mainUI() {
    return WillPopScope(
      onWillPop: () async {
        if (!_validateFields()) {
          showTopToast(context, "Please fill all fields");
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_validateFields()) {
                Navigator.pop(context);
              } else {
                showTopToast(context, "Please fill all fields");
              }
            },
          ),
          title: const Text("Add New Address"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field("House Number / Building Name*", houseController),
            const SizedBox(height: 12),

            _field("Area*", areaController, maxLines: 2),
            const SizedBox(height: 12),

            _field("Near By Landmark*", landmarkController),
            const SizedBox(height: 12),

            _field("Pin Code*", pinController,
                keyboard: TextInputType.number),
            const SizedBox(height: 20),

            Row(
              children: [
                _typeButton("Home"),
                const SizedBox(width: 10),
                _typeButton("Office"),
                const SizedBox(width: 10),
                _typeButton("Other"),
              ],
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () async {
                if (!_validateFields()) {
                  showTopToast(context, "Please fill all fields");
                  return;
                }

                loader.show(); // SHOW LOADER

                await Future.delayed(const Duration(milliseconds: 600));

                final address = {
                  "house": houseController.text.trim(),
                  "area": areaController.text.trim(),
                  "landmark": landmarkController.text.trim(),
                  "pin": pinController.text.trim(),
                  "type": selectedType,
                };

                loader.hide(); // HIDE LOADER

                Navigator.pop(context, address);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E1F),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Confirm Address",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          cursorColor: const Color(0xFFFF5E1F),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade900,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white38),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _typeButton(String type) {
    bool selected = selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF5E1F) : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
