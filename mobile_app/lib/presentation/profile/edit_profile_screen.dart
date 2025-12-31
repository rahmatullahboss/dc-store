import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/network/dio_client.dart';

/// Edit Profile Screen
/// Features: Profile picture editing, personal details form,
/// contact info section, and full dark mode support
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // Form controllers
  late TextEditingController _fullNameController;
  late TextEditingController _dobController;
  late TextEditingController _altPhoneController;

  // Gender selection
  String _selectedGender = 'Male';

  // Profile image
  File? _selectedImage;
  String? _profileImageUrl;

  // Loading state
  bool _isSaving = false;

  // User data from auth
  String _email = '';
  String _phone = '';
  final bool _emailVerified = true;
  final bool _phoneVerified = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _dobController = TextEditingController();
    _altPhoneController = TextEditingController();

    // Load user data after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  void _loadUserData() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      setState(() {
        _fullNameController.text = user.name ?? '';
        _email = user.email;
        _phone = user.phone ?? '';
        _profileImageUrl = user.image;
        // Load gender if available
        if (user.gender != null && user.gender!.isNotEmpty) {
          _selectedGender = user.gender!;
        }
        // Load date of birth if available
        if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
          _dobController.text = user.dateOfBirth!;
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    // Theme colors matching the mockup
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final subtleColor = isDark ? Colors.grey[400]! : const Color(0xFF616F89);
    final borderColor = isDark
        ? Colors.grey[800]!.withValues(alpha: 0.5)
        : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFFF97316); // Using accent color

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Sticky Header
          _buildHeader(context, isDark, bgColor, subtleColor, textColor),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  // Profile Picture Section
                  _buildProfilePicture(
                    isDark,
                    surfaceColor,
                    primaryColor,
                    user,
                  ),

                  // Form Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Personal Details Section
                        _buildPersonalDetailsSection(
                          isDark,
                          surfaceColor,
                          textColor,
                          subtleColor,
                          borderColor,
                          primaryColor,
                        ),

                        const SizedBox(height: 24),

                        // Contact Info Section
                        _buildContactInfoSection(
                          isDark,
                          surfaceColor,
                          textColor,
                          subtleColor,
                          borderColor,
                          primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Footer
          _buildFooter(isDark, primaryColor),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color bgColor,
    Color subtleColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.grey[800]!.withValues(alpha: 0.5)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cancel Button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: subtleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Title
          Text(
            'Edit Profile',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),

          // Spacer for symmetry
          const Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(
    bool isDark,
    Color surfaceColor,
    Color primaryColor,
    dynamic user,
  ) {
    // Determine what to show - selected image, profile URL, or initials
    Widget imageContent;

    if (_selectedImage != null) {
      imageContent = Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: 112,
        height: 112,
      );
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      imageContent = Image.network(
        _profileImageUrl!,
        fit: BoxFit.cover,
        width: 112,
        height: 112,
        errorBuilder: (context, error, stackTrace) =>
            _buildInitials(user, primaryColor),
      );
    } else {
      imageContent = _buildInitials(user, primaryColor);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Stack(
        children: [
          // Profile Image
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? surfaceColor : Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(child: imageContent),
          ),

          // Camera Button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _handleChangePhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF101622)
                        : const Color(0xFFF6F6F8),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.camera,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(dynamic user, Color primaryColor) {
    final name = _fullNameController.text.isNotEmpty
        ? _fullNameController.text
        : (user?.name ?? 'U');
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      color: primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsSection(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleColor,
    Color borderColor,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'PERSONAL DETAILS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtleColor,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Card
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Full Name
              _buildInputField(
                label: 'Full Name',
                controller: _fullNameController,
                placeholder: 'Enter your full name',
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
              ),

              Divider(height: 1, color: borderColor, indent: 0),

              // Date of Birth
              _buildInputField(
                label: 'Date of Birth',
                controller: _dobController,
                placeholder: 'Select date',
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
                trailing: Icon(
                  LucideIcons.calendar,
                  size: 20,
                  color: subtleColor,
                ),
                onTap: _handleDatePicker,
              ),

              Divider(height: 1, color: borderColor, indent: 0),

              // Gender
              _buildGenderSelector(
                isDark,
                textColor,
                subtleColor,
                primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleColor,
    Color borderColor,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'CONTACT INFO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtleColor,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Card
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Email (Read-only, Verified)
              _buildReadOnlyField(
                label: 'Email Address',
                value: _email.isNotEmpty ? _email : 'Not set',
                isVerified: _emailVerified,
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                primaryColor: primaryColor,
              ),

              Divider(height: 1, color: borderColor, indent: 0),

              // Phone (Verified, Changeable)
              _buildVerifiedPhoneField(
                label: 'Phone Number',
                value: _phone.isNotEmpty ? _phone : 'Not set',
                isVerified: _phoneVerified,
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                primaryColor: primaryColor,
                onChangeTap: _handleChangePhone,
              ),

              Divider(height: 1, color: borderColor, indent: 0),

              // Alternative Phone
              _buildInputField(
                label: 'Alt. Phone',
                labelSuffix: '(Optional)',
                controller: _altPhoneController,
                placeholder: '+880 1XXX-XXXXXX',
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    String? labelSuffix,
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    Widget? trailing,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subtleColor,
                  ),
                ),
                if (labelSuffix != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    labelSuffix,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: subtleColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: onTap != null,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: TextStyle(
                        color: subtleColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector(
    bool isDark,
    Color textColor,
    Color subtleColor,
    Color primaryColor,
  ) {
    final genderOptions = ['Female', 'Male', 'Other'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subtleColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genderOptions.map((gender) {
              final isSelected = _selectedGender == gender;
              return GestureDetector(
                onTap: () => setState(() => _selectedGender = gender),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : isDark
                        ? Colors.grey[700]
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.grey[300]
                          : const Color(0xFF4B5563),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required bool isVerified,
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFFAFAFA),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subtleColor,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[300] : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          if (isVerified)
            Icon(LucideIcons.shieldCheck, size: 24, color: primaryColor),
        ],
      ),
    );
  }

  Widget _buildVerifiedPhoneField({
    required String label,
    required String value,
    required bool isVerified,
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color primaryColor,
    required VoidCallback onChangeTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subtleColor,
                      ),
                    ),
                    if (isVerified && value != 'Not set') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChangeTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Change',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark, Color primaryColor) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF101622).withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 448),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSaveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: primaryColor.withValues(alpha: 0.3),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Action handlers
  void _handleChangePhoto() async {
    final picker = ImagePicker();

    // Show options bottom sheet
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Profile Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(LucideIcons.camera),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(LucideIcons.image),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (_selectedImage != null || _profileImageUrl != null)
                ListTile(
                  leading: const Icon(LucideIcons.trash2, color: Colors.red),
                  title: const Text(
                    'Remove photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                      _profileImageUrl = null;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      try {
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
        }
      }
    }
  }

  void _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dobController.text =
            '${_getMonthName(date.month)} ${date.day}, ${date.year}';
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _handleChangePhone() {
    // Show phone change dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Phone Number'),
        content: const Text(
          'Phone number change requires verification. '
          'A verification code will be sent to your new number.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Phone verification coming soon')),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleSaveChanges() async {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Call API to update profile
      final dioClient = ref.read(dioClientProvider);

      final response = await dioClient.patch<Map<String, dynamic>>(
        '/api/user/profile',
        data: {
          'name': _fullNameController.text.trim(),
          if (_selectedGender.isNotEmpty) 'gender': _selectedGender,
          if (_dobController.text.isNotEmpty)
            'dateOfBirth': _dobController.text,
          if (_altPhoneController.text.isNotEmpty)
            'phone': _altPhoneController.text,
        },
      );

      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Color(0xFF22C55E),
            ),
          );
          context.pop();
        }
      } else {
        throw Exception(response.errorMessage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
