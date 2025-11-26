// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:reel_on_go/logic/controllers/auth_controller.dart';
// import 'package:reel_on_go/core/routes/app_routes.dart';

// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final controllers = List.generate(6, (_) => TextEditingController());
//   String? phone;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)!.settings.arguments as Map;
//     phone = args["phone"];
//   }

//   String getOtp() => controllers.map((c) => c.text).join();

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthController>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Colors.black,
//           body: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 const SizedBox(height: 60),

//                 Text(
//                   "Enter OTP sent to $phone",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // OTP INPUT BOXES
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: List.generate(6, (i) {
//                     return SizedBox(
//                       width: 48,
//                       child: TextField(
//                         controller: controllers[i],
//                         maxLength: 1,
//                         textAlign: TextAlign.center,
//                         keyboardType: TextInputType.number,
//                         style: const TextStyle(color: Colors.white, fontSize: 22),
//                         decoration: InputDecoration(
//                           counterText: "",
//                           filled: true,
//                           fillColor: const Color(0xFF1A1A1A),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         onChanged: (value) {
//                           if (value.isNotEmpty && i < 5) {
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                       ),
//                     );
//                   }),
//                 ),

//                 const Spacer(),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       final otp = getOtp();

//                       if (otp.length != 6) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please enter the full 6-digit OTP"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                         return;
//                       }

//                       bool valid = await auth.verifyOTP(otp);

//                       if (valid) {
//                         await auth.createUserInFirestore();

//                         Navigator.pushReplacementNamed(
//                           context,
//                           AppRoutes.location,
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Invalid OTP"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF5E1F),
//                       minimumSize: const Size(double.infinity, 55),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: const Text(
//                       "Verify",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),

//         /// LOADING OVERLAY
//         if (auth.loading)
//           Container(
//             color: Colors.black54,
//             child: const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//           ),
//       ],
//     );
//   }
// }
