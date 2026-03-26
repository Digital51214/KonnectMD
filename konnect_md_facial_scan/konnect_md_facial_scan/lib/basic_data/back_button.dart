import 'package:flutter/material.dart';

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:Color(0xFF0088c9).withOpacity(0.38),
          border: Border.all(
            color: const Color(0xFF0088C9), // border color
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Inner shadow simulation
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.80),
                    blurRadius: 6,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),

            // Center Icon
            const Center(
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFF0088C9),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}