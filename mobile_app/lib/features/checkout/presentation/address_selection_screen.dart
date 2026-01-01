import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/white_label_config.dart';
import '../../../data/address_repository.dart';
import '../../../data/models/address/address_model.dart';
import 'providers/checkout_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // If an address was previously selected, try to keep it selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final checkoutState = ref.read(checkoutProvider);
      final addressesAsync = ref.read(addressesProvider);
      addressesAsync.whenData((addresses) {
        if (checkoutState.selectedAddress != null && addresses.isNotEmpty) {
          final idx = addresses.indexWhere(
            (a) => a.id == checkoutState.selectedAddress!.id,
          );
          if (idx >= 0) {
            setState(() => _selectedIndex = idx);
          }
        } else if (addresses.isNotEmpty) {
          // Auto-select default address or first one
          final defaultIdx = addresses.indexWhere((a) => a.isDefault);
          if (defaultIdx >= 0) {
            setState(() => _selectedIndex = defaultIdx);
          }
        }
      });
    });
  }

  void _continueToPayment(List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an address first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save selected address to checkout state
    final selectedAddress = addresses[_selectedIndex];
    ref.read(checkoutProvider.notifier).setSelectedAddress(selectedAddress);
    context.push('/checkout/payment');
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

    final addressesAsync = ref.watch(addressesProvider);

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
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 48, color: subtleColor),
              const SizedBox(height: 16),
              Text(
                'Failed to load addresses',
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(addressesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (addresses) => Column(
          children: [
            Expanded(
              child: addresses.isEmpty
                  ? _buildEmptyState(
                      textColor,
                      subtleColor,
                      surfaceColor,
                      borderColor,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: addresses.length + 1, // +1 for add button
                      itemBuilder: (context, index) {
                        if (index == addresses.length) {
                          return _buildAddNewAddressButton(
                            isDark,
                            surfaceColor,
                            textColor,
                            borderColor,
                          );
                        }
                        final address = addresses[index];
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
                    onPressed: addresses.isEmpty
                        ? null
                        : () => _continueToPayment(addresses),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WhiteLabelConfig.accentColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: isDark
                          ? Colors.grey[700]
                          : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      addresses.isEmpty
                          ? 'Add an Address First'
                          : 'Continue to Payment',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    Color textColor,
    Color subtleColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.mapPin, size: 64, color: subtleColor.withAlpha(100)),
          const SizedBox(height: 16),
          Text(
            'No addresses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a delivery address to continue',
            style: TextStyle(fontSize: 14, color: subtleColor),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/profile/addresses'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WhiteLabelConfig.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required AddressModel address,
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
                          _getTypeName(address.type),
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
                    '${address.addressLine1}\n${address.city}${address.zipCode != null && address.zipCode!.isNotEmpty ? ' ${address.zipCode}' : ''}',
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
              onPressed: () => context.push('/profile/addresses'),
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
      onTap: () => context.push('/profile/addresses'),
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

  String _getTypeName(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.office:
        return 'Office';
      case AddressType.other:
        return 'Other';
    }
  }
}
