import 'package:flutter/material.dart';

class LoaderController extends ChangeNotifier {
  bool loading = false;

  void show() {
    loading = true;
    notifyListeners();
  }

  void hide() {
    loading = false;
    notifyListeners();
  }
}
