import 'package:facial_scan_app/Bottom_Navigation_Bar/bottom_nav_screen.dart';

import 'package:facial_scan_app/basic_data/app_images.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../session manager/session_manager.dart';
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
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // 3 second wait
    await Future.delayed(const Duration(seconds: 3));

    print('SplashScreen: Checking session...');
    final isValid = await SessionManager.isSessionValid();
    print('SplashScreen: Session valid => $isValid');

    if (isValid) {
      // Session hai — seedha Home
      print('SplashScreen: Valid session — going to Home');
      Get.offAll(() => const BottomNavScreen());
    } else {
      // Session nahi — Onboarding
      print('SplashScreen: No session — going to Onboarding');
      Get.offAll(() => OnboardingScreen01());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.logo),
      ),
    );
  }
}