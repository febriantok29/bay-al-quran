import 'dart:convert';

class ArabicFormatter {
  static String format(String input) => utf8.decode(input.codeUnits);
}
