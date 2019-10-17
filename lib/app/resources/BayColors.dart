import 'package:flutter/painting.dart';

class BayColors {
  BayColors._();

  static BayColors _instance;

  factory BayColors() {
    if (_instance == null) _instance = BayColors._();
    return _instance;
  }

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFCDCDCD);
  static const Color blue = Color(0xFF57A5FF);
}
