import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'app_colors.dart';

class ProgressButton extends StatelessWidget {

  final int currentPage;
  final VoidCallback onTap;

  const ProgressButton({
    super.key,
    required this.currentPage,
    required this.onTap,
  });

  double getPercent() {
    if (currentPage == 0) return 0.38;
    if (currentPage == 1) return 0.52;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircularPercentIndicator(
        radius: 35,
        lineWidth: 3,
        percent: getPercent(),
        progressColor: Color(0xFF0088C9),
        backgroundColor: Colors.white,
        circularStrokeCap: CircularStrokeCap.round,
        center: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF0088C9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}