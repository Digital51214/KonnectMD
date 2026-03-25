
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Starting Screen/splash_screen.dart';
import 'basic_data/screen_size.dart';

void main() {
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
      home: Builder(
        builder: (context) {
          ScreenSize.init(context);
          return Splashscreen01();
        },
      ),
    );
  }
}

