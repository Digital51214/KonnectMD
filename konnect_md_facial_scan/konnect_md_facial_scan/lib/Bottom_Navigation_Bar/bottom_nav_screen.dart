import 'package:facial_scan_app/Bottom_Navigation_Bar/history_screen.dart';
import 'package:facial_scan_app/Bottom_Navigation_Bar/home_screen.dart';
import 'package:facial_scan_app/Bottom_Navigation_Bar/profile_screen.dart';
import 'package:flutter/material.dart';

import 'scan_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ScanScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF0088C9);
    const Color unselectedColor = Color(0xFF8ECAE7);
    const Color navBgColor = Color(0xFFD9EEF8);

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.home_rounded,
        'label': 'Home',
      },
      {
        'icon': Icons.face_retouching_natural_rounded,
        'label': 'Scan',
      },
      {
        'icon': Icons.history_rounded,
        'label': 'History',
      },
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Profile',
      },
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(36, 0, 36, 14),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: navBgColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: unselectedColor,
              width: 1.2,
            ),
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final bool isSelected = currentIndex == index;

              return Expanded(
                flex: isSelected ? 2 : 1,
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : unselectedColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: isSelected
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  items[index]['icon'],
                                  color: selectedColor,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  items[index]['label'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              items[index]['icon'],
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ScanDummyScreen extends StatelessWidget {
  const ScanDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DummyScreen(
      title: 'Scan Screen',
      icon: Icons.face_retouching_natural_rounded,
    );
  }
}

class HistoryDummyScreen extends StatelessWidget {
  const HistoryDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DummyScreen(
      title: 'History Screen',
      icon: Icons.history_rounded,
    );
  }
}

class ProfileDummyScreen extends StatelessWidget {
  const ProfileDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DummyScreen(
      title: 'Profile Screen',
      icon: Icons.person_outline_rounded,
    );
  }
}

class DummyScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const DummyScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF0088C9);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: selectedColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}