import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'logic/controllers/auth_controller.dart';
import 'logic/controllers/loader_controller.dart';

import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/intro/intro_screen.dart';
import 'presentation/screens/auth/login/login_screen.dart';
import 'presentation/screens/location/location_screen.dart';
import 'presentation/screens/profileSetup/profile_setup_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/bookings/book_now_screen.dart';
import 'presentation/bookings/my_bookings_screen.dart';
import 'presentation/bookings/schedule_screen.dart';
import 'presentation/screens/explore/explore_screen.dart';
import 'presentation/screens/MainWrapper.dart';

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
          cursorColor: Color(0xFFFF5E1F),
          selectionColor: Color(0x33FF5E1F),
          selectionHandleColor: Color(0xFFFF5E1F),
        ),
      ),
      title: "ReelOnGo",
      debugShowCheckedModeBanner: false,
      home: const RootRouter(),

      routes: {
        "/login": (_) => const LoginScreen(),
        "/intro": (_) => const IntroScreen(),
        "/location": (_) => const LocationScreen(),

        // ⭐ PROFILE SETUP
        "/profileSetup": (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return ProfileSetupScreen(phone: phone);
        },

        // ⭐ HOME
        "/home": (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return MainWrapper(phone: phone); // <-- Use Wrapper
        },

        // ⭐ EXPLORE
        "/explore": (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return ExploreScreen(phone: phone);
        },

        // ⭐ BOOKINGS
        "/myBookings": (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return MyBookingsScreen(phone: phone);
        },

        // ⭐ SCHEDULE
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

  Future<String?> _getPhoneFromFirestore(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data()["phone"];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Not logged in → Intro
        if (!snapshot.hasData) return const IntroScreen();

        final user = snapshot.data!;

        return FutureBuilder<String?>(
          future: _getPhoneFromFirestore(user.uid),
          builder: (context, snap) {
            if (!snap.hasData) return const SplashScreen();

            final phone = snap.data;

            if (phone == null) {
              return const LoginScreen();
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(phone)
                  .get(),
              builder: (context, userSnap) {
                if (!userSnap.hasData) return const SplashScreen();

                if (!userSnap.data!.exists) {
                  return const LoginScreen();
                }

                final data = userSnap.data!.data() as Map<String, dynamic>;

                final bool locationDone = data["isLocationSet"] == true;
                final bool profileDone = data["isProfileComplete"] == true;

                if (!locationDone) {
                  return const LocationScreen();
                }

                if (!profileDone) {
                  return ProfileSetupScreen(phone: phone);
                }

                // ⭐ MAIN WRAPPER (HOME, EXPLORE, BOOKINGS, PROFILE)
                return MainWrapper(phone: phone);
              },
            );
          },
        );
      },
    );
  }
}
