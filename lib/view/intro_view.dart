import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'mainline_view.dart';

class IntroPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return IntroWidgetState();
  }
}

class IntroWidgetState extends State<IntroPage> with TickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: const Duration(milliseconds: 2900), vsync: this);
    rotationController.forward();
    new Timer(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new InkWell(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(color: Colors.black),
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
              child: Image.asset('images/logo.png', fit: BoxFit.scaleDown),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }
}
