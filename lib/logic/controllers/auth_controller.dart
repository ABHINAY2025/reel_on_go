import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  /// -------------------------------------------------------------
  /// LOGIN USING MOBILE NUMBER (DEV MODE, NO OTP)
  /// -------------------------------------------------------------
  Future<String> loginUser(String phone) async {
    try {
      loading = true;
      notifyListeners();

      String clean = phone.replaceAll(RegExp(r'[^0-9]'), '');

      // 🔥 Ensure the user is authenticated anonymously (needed for Firestore rules)
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
      }

      // 1️⃣ Check if user exists
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(clean)
          .get();

      if (doc.exists) {
        loading = false;
        notifyListeners();
        return "existing";
      }

      // 2️⃣ Create new user
      await FirebaseFirestore.instance
          .collection("users")
          .doc(clean)
          .set({
        "phone": clean,
        "isLocationSet": false,
        "isProfileComplete": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      loading = false;
      notifyListeners();
      return "new";

    } catch (e) {
      debugPrint("Login Error: $e");
      loading = false;
      notifyListeners();
      return "error";
    }
  }

  /// -------------------------------------------------------------
  /// UPDATE USER LOCATION  (phone passed directly)
  /// -------------------------------------------------------------
  Future<void> updateUserLocation(String phone, String city) async {
    try {
      loading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(phone)
          .update({
        "city": city,
        "isLocationSet": true,
      });

    } catch (e) {
      debugPrint("Location update error: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// -------------------------------------------------------------
  /// SAVE USER PROFILE  (phone passed directly)
  /// -------------------------------------------------------------
  Future<void> saveUserProfile(String phone, Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(phone)
          .set({
        ...data,
        "isProfileComplete": true,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e) {
      debugPrint("Profile update error: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// -------------------------------------------------------------
  /// LOGOUT
  /// -------------------------------------------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }
}
