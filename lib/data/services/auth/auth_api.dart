import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {

  /// For emulator use: http://10.0.2.2:5008
  /// For real device use: http://YOUR-PC-IP:5008
  static const String baseUrl = "http://localhost:5008";

  // ----------------------
  // LOGIN (email only)
  // ----------------------
  Future<Map<String, dynamic>> login(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  // ----------------------
  // SAVE PROFILE DATA
  // ----------------------
  Future<bool> saveProfile(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/user/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> submitCreator(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/creator/apply"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }
}
