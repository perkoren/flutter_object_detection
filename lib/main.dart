import 'package:flutter/material.dart';

import 'view/intro_view.dart';

var theme = ThemeData.light().copyWith(
  snackBarTheme: ThemeData.light().snackBarTheme.copyWith(
      backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating),
  primaryColor: Colors.deepPurpleAccent,
  accentColor: Colors.deepPurple,
 );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Object Detection',
    home: IntroPage(),
  ));
}
