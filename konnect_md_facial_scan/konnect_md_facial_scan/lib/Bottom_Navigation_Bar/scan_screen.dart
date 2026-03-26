import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF7F7F7);
    const Color buttonColor = Color(0xFF0088C9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// Title
              const Text(
                "Scan Your Face",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 50),

              /// Face Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/images/scan.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// Scan Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Scan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}