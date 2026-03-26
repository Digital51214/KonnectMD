import 'dart:io';

import 'package:facial_scan_app/Other%20Screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';

import '../forgot_password/update_password_screen.dart';
import '../session manager/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName      = '';
  String userEmail     = '';
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // 1. Session se name aur email load karo
    final user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        userName  = user['username'] ?? user['name'] ?? '';
        userEmail = user['email']    ?? '';
      });
    }

    // 2. Persistent image load karo
    final savedImage = await SessionManager.getProfileImage();
    if (savedImage != null && savedImage.isNotEmpty) {
      setState(() => _profileImage = savedImage);
    }
  }

  // ✅ Edit profile se wapas aane pe name + image dono reload
  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
    await _loadUserData(); // ✅ turant updated name + image show hoga
  }

  Widget _buildAvatar(double size) {
    ImageProvider imageProvider;

    if (_profileImage.isNotEmpty && File(_profileImage).existsSync()) {
      imageProvider = FileImage(File(_profileImage));
    } else {
      imageProvider = const AssetImage('assets/images/profile.jpg');
    }

    return Image(image: imageProvider, fit: BoxFit.cover);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context:            context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical:   28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width:  72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEDED),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFC62828),
                        size:  34,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize:   20,
                        fontWeight: FontWeight.w700,
                        color:      Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Are you sure you want\nto logout?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w400,
                        color:      Color(0xFF8E8E8E),
                        height:     1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(
                                color: Color(0xFFD8D8D8),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontSize:   15,
                                fontWeight: FontWeight.w600,
                                color:      Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                              setDialogState(() => isLoading = true);
                              await SessionManager.logoutAndRedirect();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              elevation:               0,
                              backgroundColor:         const Color(0xFFC62828),
                              disabledBackgroundColor: const Color(0xFFE57373),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width:  20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color:       Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Yes',
                              style: TextStyle(
                                fontSize:   15,
                                fontWeight: FontWeight.w600,
                                color:      Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor      = Color(0xFFF7F7F7);
    const Color primaryColor = Color(0xFF0088C9);
    const Color greyText     = Color(0xFF8E8E8E);
    const Color redColor     = Color(0xFFC62828);
    const Color borderColor  = Color(0xFFD8D8D8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 78),

              /// ── Profile Picture ──────────────────────────────
              Container(
                width:        122,
                height:       122,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:      Color(0x22000000),
                      blurRadius: 12,
                      offset:     Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildAvatar(122),
              ),

              const SizedBox(height: 14),

              /// ── Name ─────────────────────────────────────────
              Text(
                userName.isEmpty ? '...' : userName,
                style: const TextStyle(
                  fontSize:   18,
                  fontWeight: FontWeight.w700,
                  color:      Colors.black,
                ),
              ),

              const SizedBox(height: 4),

              /// ── Email ────────────────────────────────────────
              Text(
                userEmail.isEmpty ? '...' : userEmail,
                style: const TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                  color:      greyText,
                ),
              ),

              const SizedBox(height: 16),

              /// ── Edit Profile Button ───────────────────────────
              SizedBox(
                width:  158,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _goToEditProfile, // ✅ reload ke saath
                  style: ElevatedButton.styleFrom(
                    elevation:       0,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon:  const Icon(Icons.edit, size: 16, color: Colors.white),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w700,
                      color:      Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ── Change Password ───────────────────────────────
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePassword(),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical:   18,
                  ),
                  decoration: BoxDecoration(
                    color:        Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border:       Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lock, color: Colors.black, size: 24),
                      SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize:   16,
                            fontWeight: FontWeight.w600,
                            color:      Color(0xFF7C7C7C),
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.black, size: 28),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// ── Logout Button ─────────────────────────────────
              OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  side: const BorderSide(color: Color(0xFFE44B4B), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, color: redColor, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize:   16,
                        fontWeight: FontWeight.w700,
                        color:      redColor,
                      ),
                    ),
                  ],
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