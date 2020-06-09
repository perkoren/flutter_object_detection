import 'package:flutter/material.dart';
import 'camera_view.dart';

class MainScreen extends StatefulWidget {

  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CameraScreen(model: ProfileModel()),
    );
  }
}
