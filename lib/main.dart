import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Providers
import 'package:provider/provider.dart';
import 'logic/controllers/auth_controller.dart';
import 'logic/controllers/loader_controller.dart';

// Screens
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/intro/intro_screen.dart';
import 'presentation/screens/auth/login/login_screen.dart';
// import 'presentation/screens/auth/otp/otp_screen.dart';
import 'presentation/screens/location/location_screen.dart';
import 'presentation/screens/profileSetup/profile_setup_screen.dart';
import 'presentation/bookings/book_now_screen.dart';
import 'presentation/bookings/my_bookings_screen.dart'; 
import 'presentation/bookings/schedule_screen.dart';
import 'presentation/screens/home/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => LoaderController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFFFF5E1F),            // ORANGE cursor
      selectionColor: Color(0x33FF5E1F),         // light orange highlight
      selectionHandleColor: Color(0xFFFF5E1F),   // ORANGE selection handle (the drop)
    ),
  ),
      title: "ReelOnGo",
      debugShowCheckedModeBanner: false,

      // Master Router
      home: const RootRouter(),

      // Static Routes
      routes: {
        "/login": (_) => const LoginScreen(),
        // "/otp": (_) => const OtpScreen(), //future use
        "/intro": (_) => const IntroScreen(),
        "/location": (_) => const LocationScreen(),
        "/profileSetup": (_) => const ProfileSetupScreen(),
        "/home": (_) => const HomeScreen(),
        "/myBookings": (_) => const MyBookingsScreen(),
          "/schedule": (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return ScheduleScreen(phone: phone);
        },

      },
    );
  }
}

class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 🔥 No user logged in
        if (!snapshot.hasData) return const IntroScreen();

        final user = FirebaseAuth.instance.currentUser!;

        // 🔥 If anonymous login (NO OTP)
        if (user.isAnonymous) {
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .where("uid", isEqualTo: user.uid)
                .limit(1)
                .get(),
            builder: (context, snap) {
              if (!snap.hasData) return const SplashScreen();

              if (snap.data!.docs.isEmpty) {
                print("❌ Firestore user doc missing for UID.");
                return const LoginScreen();
              }

              final data = snap.data!.docs.first.data() as Map<String, dynamic>;

              final bool locationDone = data["isLocationSet"] == true;
              final bool profileDone = data["isProfileComplete"] == true;

              if (!locationDone) return const LocationScreen();
              if (!profileDone) return const ProfileSetupScreen();

              return const HomeScreen();
            },
          );
        }

        // 🔥 If someday you add real OTP login back
        // we still keep the old logic
        return const HomeScreen();
      },
    );
  }
}

