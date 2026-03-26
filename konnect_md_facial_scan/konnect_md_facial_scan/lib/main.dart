import 'package:facial_scan_app/Bottom_Navigation_Bar/bottom_nav_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Starting Screen/splash_screen.dart';
import 'authentication_screen/sign_in.dart';
import 'basic_data/screen_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),

      /// ── GetX Routes ─────────────────────────────────
      getPages: [
        GetPage(name: '/signin',  page: () => const Sign_In()),
        GetPage(name: '/home',    page: () => const BottomNavScreen()),
      ],

      home: Builder(
        builder: (context) {
          ScreenSize.init(context);
          return Splashscreen01();
        },
      ),
    );
  }
}