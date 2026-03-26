import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/edit_profile_service.dart';
import '../session manager/session_manager.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool  _isLoading  = true;
  bool  _isUpdating = false;

  int    _userId         = 0;
  File?  _pickedImage;
  String _localImagePath = '';
  String _remoteImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // 1. Load user info from session
    final user = await SessionManager.getUser();
    if (user != null) {
      _nameController.text = user['name'] ?? user['username'] ?? '';
      _userId = int.tryParse(user['id']?.toString() ?? '0') ?? 0;
    }

    // 2. Load persistent profile image from SessionManager
    final savedImage = await SessionManager.getProfileImage();
    if (savedImage != null && savedImage.isNotEmpty) {
      _localImagePath = savedImage;
    }

    // 3. Load remote image URL as fallback
    final remoteUrl = await ProfileService.getRemoteImageUrl();
    if (remoteUrl != null && remoteUrl.isNotEmpty) {
      _remoteImageUrl = remoteUrl;
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Image Picker ─────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source:       source,
      imageQuality: 80,
      maxWidth:     800,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context:         context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width:  40,
                height: 4,
                decoration: BoxDecoration(
                  color:        Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFDDF2FB),
                  child: Icon(Icons.camera_alt, color: Color(0xFF0088C9)),
                ),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (!mounted) return;
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFDDF2FB),
                  child: Icon(Icons.photo_library, color: Color(0xFF0088C9)),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (!mounted) return;
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Avatar ───────────────────────────────────────────────────────
  Widget _buildAvatar() {
    ImageProvider imageProvider;

    if (_pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (_localImagePath.isNotEmpty &&
        File(_localImagePath).existsSync()) {
      imageProvider = FileImage(File(_localImagePath));
    } else if (_remoteImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(_remoteImageUrl);
    } else {
      imageProvider = const AssetImage('assets/images/profile.jpg');
    }

    return Image(image: imageProvider, fit: BoxFit.cover);
  }

  // ── Update Handler ───────────────────────────────────────────────
  Future<void> _handleUpdate() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showSnack('Please enter your full name', isError: true);
      return;
    }

    setState(() => _isUpdating = true);

    final result = await ProfileService.updateProfile(
      userId:           _userId,
      username:         name,
      profileImageFile: _pickedImage,
    );

    if (result['success'] == true) {
      // ✅ Session mein updated name save karo
      final user = await SessionManager.getUser();
      if (user != null) {
        user['username'] = name;
        user['name']     = name;
        await SessionManager.saveSession(user: user);
      }

      // ✅ Image SessionManager mein save karo
      if (_pickedImage != null) {
        await SessionManager.saveProfileImage(_pickedImage!.path);
        setState(() {
          _localImagePath = _pickedImage!.path;
          _pickedImage    = null;
        });
      }

      // ✅ Remote URL save karo
      final responseData = result['data'] as Map<String, dynamic>?;
      final returnedUrl  = responseData?['profile_pic']?.toString() ?? '';
      if (returnedUrl.isNotEmpty) {
        await ProfileService.saveRemoteImageUrl(returnedUrl);
        setState(() => _remoteImageUrl = returnedUrl);
      }

      _showSnack('Profile updated successfully!');
    } else {
      _showSnack(result['message'] ?? 'Update failed', isError: true);
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

  // ── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const Color bgColor      = Color(0xFFF7F7F7);
    const Color primaryColor = Color(0xFF0088C9);
    const Color lightBlue    = Color(0xFFDDF2FB);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 22),

              // ── Back Button + Title ──────────────────────
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
                    'Edit Profile',
                    style: TextStyle(
                      fontSize:   22,
                      fontWeight: FontWeight.w700,
                      color:      Color(0xFF202020),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // ── Profile Avatar ───────────────────────────
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width:        112,
                      height:       112,
                      decoration: BoxDecoration(
                        shape:  BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildAvatar(),
                    ),
                    Positioned(
                      right:  -2,
                      bottom: -2,
                      child: Container(
                        width:  34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size:  18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 54),

              // ── Name Field ───────────────────────────────
              _ProfileTextField(
                hintText:   'Full Name',
                controller: _nameController,
              ),

              const SizedBox(height: 24),

              // ── Update Button ────────────────────────────
              SizedBox(
                width:  double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _isUpdating ? null : _handleUpdate,
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

// ── Reusable Text Field ──────────────────────────────────────────────────────
class _ProfileTextField extends StatelessWidget {
  final String                hintText;
  final TextEditingController controller;
  final TextInputType          keyboardType;

  const _ProfileTextField({
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:   controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText:  hintText,
        hintStyle: const TextStyle(
          fontSize:   14,
          fontWeight: FontWeight.w600,
          color:      Colors.black45,
        ),
        filled:         true,
        fillColor:      Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical:   16,
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