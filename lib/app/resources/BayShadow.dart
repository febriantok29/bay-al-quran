import 'package:bay_al_quran/app/resources/BayColors.dart';
import 'package:flutter/painting.dart';

class BayShadow {
  BayShadow._();

  static BayShadow _instance;

  factory BayShadow() {
    if (_instance == null) _instance = BayShadow._();
    return _instance;
  }

  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: BayColors.grey,
      offset: Offset(0.0, 3.0),
    ),
  ];
}
