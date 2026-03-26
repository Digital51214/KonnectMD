import 'dart:io';

import 'package:flutter/material.dart';

import '../session manager/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName      = '';
  String userEmail     = '';
  String _profileImage = ''; // ✅ image path

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        userName  = user['username'] ?? '';
        userEmail = user['email']    ?? '';
      });
    }

    // ✅ SessionManager se persistent image load karo
    final savedImage = await SessionManager.getProfileImage();
    if (savedImage != null && savedImage.isNotEmpty) {
      setState(() => _profileImage = savedImage);
    }
  }

  // ✅ Avatar builder
  Widget _buildAvatar() {
    ImageProvider imageProvider;

    if (_profileImage.isNotEmpty && File(_profileImage).existsSync()) {
      imageProvider = FileImage(File(_profileImage));
    } else {
      imageProvider = const AssetImage('assets/images/profile.jpg');
    }

    return Image(image: imageProvider, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF0088C9);
    const Color screenBg      = Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// top bar
              Row(
                children: [
                  // ✅ Profile image
                  Container(
                    width:        48,
                    height:       48,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: _buildAvatar(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize:   13,
                            color:      Color(0xFF9A9A9A),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userName.isEmpty ? '...' : userName,
                          style: const TextStyle(
                            fontSize:   17.5,
                            color:      Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width:  52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDDF2FB),
                      border: Border.all(
                        color: const Color(0xFF9DD8F1),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color:      Color(0x14000000),
                          blurRadius: 8,
                          offset:     Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: selectedColor,
                      size:  24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// facial scan card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical:   24,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color:        const Color(0xFFDDE8EF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Image.asset("assets/images/facial.png"),
                    const SizedBox(height: 16),
                    const Text(
                      'Start Facial Scan',
                      style: TextStyle(
                        fontSize:   16,
                        fontWeight: FontWeight.w700,
                        color:      Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Analyze vitals in 30 Seconds',
                      style: TextStyle(
                        fontSize:   15,
                        fontWeight: FontWeight.w400,
                        color:      Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Quick Vitals',
                style: TextStyle(
                  fontSize:   16,
                  fontWeight: FontWeight.w500,
                  color:      Colors.black,
                ),
              ),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics:         const NeverScrollableScrollPhysics(),
                crossAxisCount:  2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
                children: const [
                  VitalCard(
                    title:     'Heart Rate',
                    value:     '124',
                    unit:      'bpm',
                    icon:      Icons.favorite_outline,
                    iconColor: Color(0xFFFF5A1F),
                    chartType: VitalChartType.heart,
                  ),
                  VitalCard(
                    title:     'Body Temp',
                    value:     '37.1',
                    unit:      'C°',
                    icon:      Icons.device_thermostat_outlined,
                    iconColor: Color(0xFFFF6A3D),
                    chartType: VitalChartType.temp,
                  ),
                  VitalCard(
                    title:            'Blood Oxygen',
                    value:            '102',
                    unit:             '/70',
                    trailingText:      'O2',
                    trailingTextColor: Color(0xFF2D8CFF),
                    chartType:        VitalChartType.oxygen,
                  ),
                  VitalCard(
                    title:     'Blood Pressure',
                    value:     '102',
                    unit:      '/70',
                    icon:      Icons.bubble_chart_outlined,
                    iconColor: Color(0xFFFF5A1F),
                    chartType: VitalChartType.pressure,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── VitalCard ────────────────────────────────────────────────────────────────

class VitalCard extends StatelessWidget {
  final String        title;
  final String        value;
  final String        unit;
  final IconData?     icon;
  final Color?        iconColor;
  final String?       trailingText;
  final Color?        trailingTextColor;
  final VitalChartType chartType;

  const VitalCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.chartType,
    this.icon,
    this.iconColor,
    this.trailingText,
    this.trailingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBorder = Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(18),
        border:       Border.all(color: cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize:   13,
                    color:      Color(0xFF5F5F5F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width:  38,
                height: 38,
                decoration: BoxDecoration(
                  shape:  BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD7D7D7), width: 1),
                ),
                child: Center(
                  child: trailingText != null
                      ? Text(
                    trailingText!,
                    style: TextStyle(
                      color:      trailingTextColor ?? Colors.blue,
                      fontSize:   15,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      : Icon(
                    icon ?? Icons.favorite_outline,
                    size:  20,
                    color: iconColor ?? Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize:   22,
                  height:     1,
                  fontWeight: FontWeight.w700,
                  color:      Colors.black,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize:   15,
                    fontWeight: FontWeight.w700,
                    color:      Color(0xFF5B5B5B),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 42,
            width:  double.infinity,
            child: CustomPaint(
              painter: VitalChartPainter(chartType: chartType),
            ),
          ),
        ],
      ),
    );
  }
}

enum VitalChartType { heart, temp, oxygen, pressure }

class VitalChartPainter extends CustomPainter {
  final VitalChartType chartType;
  VitalChartPainter({required this.chartType});

  @override
  void paint(Canvas canvas, Size size) {
    switch (chartType) {
      case VitalChartType.heart:    _drawHeart(canvas, size); break;
      case VitalChartType.temp:     _drawTemp(canvas, size);  break;
      case VitalChartType.oxygen:   _drawBars(canvas, size, const Color(0xFF2D6BFF)); break;
      case VitalChartType.pressure: _drawBars(canvas, size, const Color(0xFFFF5A1F)); break;
    }
  }

  void _drawHeart(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin:  Alignment.topCenter,
        end:    Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF5A1F).withOpacity(0.20),
          const Color(0xFFFF5A1F).withOpacity(0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color       = const Color(0xFFFF5A1F)
      ..strokeWidth = 1.6
      ..style       = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(size.width * 0.00, size.height * 0.72),
      Offset(size.width * 0.07, size.height * 0.72),
      Offset(size.width * 0.12, size.height * 0.26),
      Offset(size.width * 0.18, size.height * 0.78),
      Offset(size.width * 0.26, size.height * 0.48),
      Offset(size.width * 0.33, size.height * 0.67),
      Offset(size.width * 0.41, size.height * 0.52),
      Offset(size.width * 0.50, size.height * 0.58),
      Offset(size.width * 0.57, size.height * 0.25),
      Offset(size.width * 0.65, size.height * 0.72),
      Offset(size.width * 0.73, size.height * 0.40),
      Offset(size.width * 0.80, size.height * 0.77),
      Offset(size.width * 0.88, size.height * 0.30),
      Offset(size.width * 0.95, size.height * 0.72),
      Offset(size.width * 1.00, size.height * 0.72),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) path.lineTo(p.dx, p.dy);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  void _drawTemp(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color       = const Color(0xFFFFD9CC)
      ..strokeWidth = 1.2
      ..style       = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color       = const Color(0xFFFF7B4A)
      ..strokeWidth = 1.6
      ..style       = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.70, size.height * 0.75),
      basePaint,
    );

    final path = Path()
      ..moveTo(size.width * 0.70, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.78, size.height * 0.75,
        size.width * 0.86, size.height * 0.60,
      )
      ..lineTo(size.width, size.height * 0.40);

    canvas.drawPath(path, linePaint);
  }

  void _drawBars(Canvas canvas, Size size, Color highlightColor) {
    final greyPaint = Paint()
      ..color       = const Color(0xFFE4E4E4)
      ..strokeWidth = 3
      ..strokeCap   = StrokeCap.round;

    final activePaint = Paint()
      ..color       = highlightColor
      ..strokeWidth = 3
      ..strokeCap   = StrokeCap.round;

    final heights = [
      0.78, 0.88, 0.70, 0.84, 0.76,
      0.80, 0.72, 0.75, 0.79, 0.73,
      0.69, 0.74, 0.82, 0.66,
    ];

    final gap = size.width / 15.5;

    for (int i = 0; i < heights.length; i++) {
      final x     = gap * (i + 1);
      final h     = size.height * heights[i];
      final paint = i == heights.length - 1 ? activePaint : greyPaint;
      canvas.drawLine(
        Offset(x, size.height - 2),
        Offset(x, size.height - h),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}