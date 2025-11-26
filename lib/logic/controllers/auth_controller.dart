import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  /// -------------------------------------------------------------
  /// LOGIN WITHOUT OTP  (DEV MODE) — Anonymous + Firestore phone doc
  /// -------------------------------------------------------------
Future<bool> loginWithoutOTP(String phone) async {
  try {
    loading = true;
    notifyListeners();

    // 1️⃣ Sign in anonymously
    UserCredential cred = await _auth.signInAnonymously();
    User user = cred.user!;

    // 2️⃣ Clean phone number for Firestore doc ID
    String clean = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // 3️⃣ Create / Update Firestore doc (ID = phone)
    await FirebaseFirestore.instance
        .collection("users")
        .doc(clean)
        .set({
      "phone": clean,
      "uid": user.uid,

      "isLocationSet": false,
      "isProfileComplete": false,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    loading = false;
    notifyListeners();
    return true;

  } catch (e) {
    print("DEV Login Error: $e");
    loading = false;
    notifyListeners();
    return false;
  }
}


  /// -------------------------------------------------------------
  /// Resolve phone doc ID from logged-in user
  /// (We MUST get phone from the users collection)
  /// -------------------------------------------------------------
  Future<String> _resolvePhone() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      throw Exception("User document not found for UID: $uid");
    }

    return snap.docs.first.id; // phone number doc ID
  }

  /// -------------------------------------------------------------
  /// UPDATE USER LOCATION
  /// -------------------------------------------------------------
  Future<void> updateUserLocation(String city) async {
    try {
      loading = true;
      notifyListeners();

      final phone = await _resolvePhone();

      await FirebaseFirestore.instance.collection("users").doc(phone).update({
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
  /// UPDATE USER PROFILE
  /// -------------------------------------------------------------
  Future<void> saveUserProfile(Map<String, dynamic> data) async {
    try {
      loading = true;
      notifyListeners();

      final phone = await _resolvePhone();

      await FirebaseFirestore.instance.collection("users").doc(phone).set({
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
