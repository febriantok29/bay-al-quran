import 'package:bay_al_quran/app/pages/Home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bay Al Quran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Bay Al Quran Home Page'),
    );
  }
}
