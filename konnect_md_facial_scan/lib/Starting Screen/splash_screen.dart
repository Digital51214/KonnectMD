import 'package:facial_scan_app/basic_data/app_images.dart';
import 'package:flutter/material.dart';
import 'on_boarding_screen.dart';
class Splashscreen01 extends StatefulWidget {
  const Splashscreen01({super.key});

  @override
  State<Splashscreen01> createState() => _Splashscreen01State();
}

class _Splashscreen01State extends State<Splashscreen01> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen01()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
    Center(
      child: Image.asset(AppImages.logo),
    )
    );
  }
}
