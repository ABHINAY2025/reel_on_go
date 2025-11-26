import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reel_on_go/logic/controllers/loader_controller.dart';
import 'package:flutter/material.dart';

class HttpService {
  static Future<http.Response> post(
      BuildContext context, String url, Map<String, dynamic> body) async {
    
    final loader = Provider.of<LoaderController>(context, listen: false);

    try {
      loader.show();

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      return response;
    } finally {
      loader.hide();
    }
  }
}
