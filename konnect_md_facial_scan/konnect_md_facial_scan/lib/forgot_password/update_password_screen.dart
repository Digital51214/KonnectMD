import 'package:flutter/material.dart';

import '../basic_data/text_styles.dart';
import '../services/update_password_service.dart';
import '../session manager/session_manager.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController     = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isUpdating  = false;
  bool _showCurrent = false;
  bool _showNew     = false;
  bool _showConfirm = false;

  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        _userId = int.tryParse(user['id']?.toString() ?? '0') ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword     = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      _showSnack('Please enter your current password', isError: true);
      return;
    }
    if (newPassword.isEmpty) {
      _showSnack('Please enter a new password', isError: true);
      return;
    }
    if (newPassword.length < 8) {
      _showSnack('New password must be at least 8 characters', isError: true);
      return;
    }
    if (confirmPassword.isEmpty) {
      _showSnack('Please confirm your new password', isError: true);
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }
    if (currentPassword == newPassword) {
      _showSnack('New password cannot be same as current password', isError: true);
      return;
    }

    setState(() => _isUpdating = true);

    final result = await UpdatePasswordService.changePassword(
      userId:                  _userId,
      currentPassword:         currentPassword,
      newPassword:             newPassword,
      newPasswordConfirmation: confirmPassword,
    );

    if (result['success'] == true) {
      _showSnack(result['message'] ?? 'Password updated successfully!');
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack(result['message'] ?? 'Password update failed', isError: true);
    }

    setState(() => _isUpdating = false);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF0088C9),
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor      = Color(0xFFF7F7F7);
    const Color primaryColor = Color(0xFF0088C9);
    const Color lightBlue    = Color(0xFFDDF2FB);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 22),

              // ── Back Button + Title ────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width:  44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightBlue,
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
                        Icons.arrow_back_ios_new,
                        color: primaryColor,
                        size:  20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 26),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize:   22,
                      fontWeight: FontWeight.w700,
                      color:      Color(0xFF202020),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
Icon(Icons.lock,size:MediaQuery.of(context).size.width*0.5,color: primaryColor),
              const SizedBox(height: 35),
              // ── Current Password ───────────────────────────────
              _PasswordTextField(
                hintText:   'Current Password',
                controller: _currentPasswordController,
                showText:   _showCurrent,
                onToggle:   () => setState(() => _showCurrent = !_showCurrent),
              ),

              const SizedBox(height: 15),

              // ── New Password ───────────────────────────────────
              _PasswordTextField(
                hintText:   'New Password',
                controller: _newPasswordController,
                showText:   _showNew,
                onToggle:   () => setState(() => _showNew = !_showNew),
              ),

              const SizedBox(height: 15),

              // ── Confirm New Password ───────────────────────────
              _PasswordTextField(
                hintText:   'Confirm New Password',
                controller: _confirmPasswordController,
                showText:   _showConfirm,
                onToggle:   () => setState(() => _showConfirm = !_showConfirm),
              ),

              const SizedBox(height: 24),

              // ── Update Button — exact same as Edit Profile ─────
              SizedBox(
                width:  double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _isUpdating ? null : _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:         primaryColor,
                    disabledBackgroundColor: primaryColor.withOpacity(0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                    width:  22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color:       Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Update',
                    style: TextStyle(
                      fontSize:   16,
                      fontWeight: FontWeight.w700,
                      color:      Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Password Text Field — exact same style as _ProfileTextField ──────────────
class _PasswordTextField extends StatelessWidget {
  final String                hintText;
  final TextEditingController controller;
  final bool                  showText;
  final VoidCallback          onToggle;

  const _PasswordTextField({
    required this.hintText,
    required this.controller,
    required this.showText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:  controller,
      obscureText: !showText,
      decoration: InputDecoration(
        hintText:  hintText,
        hintStyle:AppTextStyles.t3.copyWith(fontSize: MediaQuery.of(context).size.width * 0.035),
        filled:         true,

        fillColor:      Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical:   16,
        ),
        // ✅ Eye toggle suffix only — exact same border style
        suffixIcon: IconButton(
          icon: Icon(
            showText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black45,
            size:  20,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFFD8D8D8),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFF0088C9),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}