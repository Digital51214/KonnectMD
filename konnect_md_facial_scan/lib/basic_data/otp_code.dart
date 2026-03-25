import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatelessWidget {
  const OtpField({super.key});

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 46,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0x1A0088C9), // #0088C9 with opacity
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    return Center(
      child: Pinput(
        length: 6, // 6 digit OTP
        defaultPinTheme: defaultPinTheme,
      ),
    );
  }
}