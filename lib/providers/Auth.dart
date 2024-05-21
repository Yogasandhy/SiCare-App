import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
  //TODO:
}
