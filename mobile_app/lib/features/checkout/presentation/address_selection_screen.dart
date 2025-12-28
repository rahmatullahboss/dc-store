import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/white_label_config.dart';

/// Address Selection Screen for Checkout
class AddressSelectionScreen extends ConsumerStatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  ConsumerState<AddressSelectionScreen> createState() =>
      _AddressSelectionScreenState();
}

class _AddressSelectionScreenState
    extends ConsumerState<AddressSelectionScreen> {
  int _selectedIndex = 0;

  // Mock addresses - in production, fetch from API
  final _addresses = [
    _Address(
      id: '1',
      type: 'Home',
      name: 'John Doe',
      address: '123 Main Street, Gulshan 1',
      city: 'Dhaka',
      postalCode: '1212',
      phone: '01712345678',
      isDefault: true,
    ),
    _Address(
      id: '2',
      type: 'Office',
      name: 'John Doe',
      address: '456 Business Center, Motijheel',
      city: 'Dhaka',
      postalCode: '1000',
      phone: '01798765432',
      isDefault: false,
    ),
  ];

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
          'Select Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length + 1, // +1 for add button
              itemBuilder: (context, index) {
                if (index == _addresses.length) {
                  return _buildAddNewAddressButton(
                    isDark,
                    surfaceColor,
                    textColor,
                    borderColor,
                  );
                }
                final address = _addresses[index];
                return _buildAddressCard(
                  address: address,
                  isSelected: _selectedIndex == index,
                  onTap: () => setState(() => _selectedIndex = index),
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  borderColor: borderColor,
                );
              },
            ),
          ),
          // Continue Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/checkout/payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WhiteLabelConfig.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue to Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required _Address address,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color surfaceColor,
    required Color textColor,
    required Color subtleColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? WhiteLabelConfig.accentColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? WhiteLabelConfig.accentColor
                      : subtleColor,
                  width: 2,
                ),
                color: isSelected
                    ? WhiteLabelConfig.accentColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: WhiteLabelConfig.accentColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          address.type,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: WhiteLabelConfig.accentColor,
                          ),
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address.address}\n${address.city} ${address.postalCode}',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.phone,
                    style: TextStyle(fontSize: 13, color: subtleColor),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push('/address/${address.id}/edit'),
              icon: Icon(LucideIcons.edit2, size: 18, color: subtleColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return GestureDetector(
      onTap: () => context.push('/address/add'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: WhiteLabelConfig.accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                LucideIcons.plus,
                color: WhiteLabelConfig.accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Add New Address',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: WhiteLabelConfig.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Address {
  final String id;
  final String type;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final bool isDefault;

  _Address({
    required this.id,
    required this.type,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.isDefault,
  });
}
