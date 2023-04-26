import 'package:flutter/material.dart';

class GlobalNotifier extends ChangeNotifier {
  int pageSelectionIndex = 0;

  void updatePageSelection(int index) {
    pageSelectionIndex = index;
    notifyListeners();
  }
}
