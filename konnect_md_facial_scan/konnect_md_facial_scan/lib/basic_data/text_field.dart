import 'package:facial_scan_app/basic_data/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const RoundedTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
  });

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 345,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF646464),
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility :Icons.visibility_off ,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
class AppButton extends StatelessWidget {
  final String text; // ✅ REQUIRED
  final VoidCallback onPressed;
  final bool isPrimary;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 333,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
       color: Colors.blue,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
class AuthRichText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  const AuthRichText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: normalText,
            style: GoogleFonts.poppins(
              color:Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: actionText,

                style: GoogleFonts.poppins(
                  color: AppColors.blueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ClickableRichText extends StatelessWidget {
  final String normalText;
  final String secondText;
  final String actionText;
  final String thirdText;
  final VoidCallback? onSecondTap;
  final VoidCallback? onThirdTap;

  const ClickableRichText({
    super.key,
    required this.normalText,
    required this.secondText,
    required this.actionText,
    required this.thirdText,
    this.onSecondTap,
    this.onThirdTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: normalText, // 1st span
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: secondText, // 2nd span
              style: GoogleFonts.poppins(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              recognizer: TapGestureRecognizer()..onTap = onSecondTap,
            ),
            TextSpan(
              text: actionText, // 3rd span
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: thirdText, // 4th span
              style: GoogleFonts.poppins(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              recognizer: TapGestureRecognizer()..onTap = onThirdTap,
            ),
          ],
        ),
      ),
    );
  }
}

class EmailTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const EmailTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.emailAddress,
  });

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 345,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF646464),
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}



class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const PasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 345,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        maxLength: 8,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
        ],
        decoration: InputDecoration(
          counterText: "", // hides character counter
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF646464),
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          ),
        ),
      ),
    );
  }
}