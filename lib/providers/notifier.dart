import 'package:flutter/material.dart';

class PasswordNotifier extends ChangeNotifier {
  void shouldRefresh() {
    notifyListeners();
  }
}
