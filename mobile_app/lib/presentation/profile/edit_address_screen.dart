import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/config/white_label_config.dart';

/// Edit Address Screen - Similar to Add but pre-filled
class EditAddressScreen extends ConsumerStatefulWidget {
  final String addressId;

  const EditAddressScreen({super.key, required this.addressId});

  @override
  ConsumerState<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends ConsumerState<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _addressType = 'Home';
  bool _isDefault = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with mock data - in production, fetch from API
    _nameController.text = 'John Doe';
    _phoneController.text = '01712345678';
    _addressController.text = '123 Main Street, Gulshan';
    _cityController.text = 'Dhaka';
    _postalCodeController.text = '1212';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: const Text('Address updated successfully'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      context.pop();
    }
  }

  Future<void> _deleteAddress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: const Text('Address deleted'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
        ),
        title: Text(
          'Edit Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _deleteAddress,
            icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Type
              Text(
                'Address Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTypeChip(
                    'Home',
                    LucideIcons.home,
                    isDark,
                    textColor,
                    borderColor,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeChip(
                    'Office',
                    LucideIcons.briefcase,
                    isDark,
                    textColor,
                    borderColor,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeChip(
                    'Other',
                    LucideIcons.mapPin,
                    isDark,
                    textColor,
                    borderColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                isDark: isDark,
                surfaceColor: surfaceColor,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                isDark: isDark,
                surfaceColor: surfaceColor,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
                validator: (v) => v!.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Street Address',
                hint: 'House number, street name, area',
                maxLines: 2,
                isDark: isDark,
                surfaceColor: surfaceColor,
                textColor: textColor,
                subtleColor: subtleColor,
                borderColor: borderColor,
                validator: (v) => v!.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      hint: 'City name',
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subtleColor: subtleColor,
                      borderColor: borderColor,
                      validator: (v) => v!.isEmpty ? 'City is required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: '1234',
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subtleColor: subtleColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Default Address Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.star, size: 20, color: subtleColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Set as default address',
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (v) => setState(() => _isDefault = v),
                      activeThumbColor: WhiteLabelConfig.accentColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WhiteLabelConfig.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    String label,
    IconData icon,
    bool isDark,
    Color textColor,
    Color borderColor,
  ) {
    final isSelected = _addressType == label;
    return GestureDetector(
      onTap: () => setState(() => _addressType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? WhiteLabelConfig.accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? WhiteLabelConfig.accentColor : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subtleColor),
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: WhiteLabelConfig.accentColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
