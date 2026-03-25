import 'package:facial_scan_app/authentication_screen/sign_in.dart';
import 'package:flutter/material.dart';
import '../basic_data/app_images.dart';
import '../basic_data/circle_button.dart';
import '../basic_data/text_styles.dart';
import '../basic_data/screen_size.dart';

class OnboardingScreen01 extends StatefulWidget {
  const OnboardingScreen01({super.key});

  @override
  State<OnboardingScreen01> createState() => _OnboardingScreen01State();
}

class _OnboardingScreen01State extends State<OnboardingScreen01> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppImages.sp1,
      "title": "AI Facial Health\n Scan",
      "desc":
      "Scan your face in seconds and\n get AI-powered insights about\n your vital signs",
    },
    {
      "image": AppImages.sp2,
      "title": "Fast & Contactless\n Monitoring",
      "desc": "Check your vitals without any\n medical devices",
    },
    {
      "image": AppImages.sp3,
      "title": "Track Your\n Health Insights",
      "desc": "View your results with easy-to\n-understand charts and\n insights",
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Sign_In()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: ScreenSize.height * 0.12),
                      Image.asset(onboardingData[index]["image"]!

                        ),
                      SizedBox(height: ScreenSize.height * 0.04),
                      Text(
                        onboardingData[index]["title"]!,
                        style: AppTextStyles.heading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        onboardingData[index]["desc"]!,
                        style: AppTextStyles.subHeading,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Circular Progress Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ProgressButton(currentPage: currentPage, onTap: nextPage),
          ),
          SizedBox(height: ScreenSize.height * 0.05),
        ],
      ),
    );
  }
}