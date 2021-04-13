import 'package:flutter/material.dart';
import '../view/homepage.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

  MaterialColor beaverOrange = MaterialColor(
    0xFFD73F09,
    <int, Color>{
      50: Color(0xFFD73F09),
      100: Color(0xFFD73F09),
      200: Color(0xFFD73F09),
      300: Color(0xFFD73F09),
      400: Color(0xFFD73F09),
      500: Color(0xFFD73F09),
      600: Color(0xFFD73F09),
      700: Color(0xFFD73F09),
      800: Color(0xFFD73F09),
      900: Color(0xFFD73F09),
    }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: beaverOrange,
      ),
      home: MyHomePage(),
    );
  }
}