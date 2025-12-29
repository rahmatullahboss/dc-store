import 'package:flutter/material.dart';
import 'package:dc_store/core/theme/app_colors.dart';
import 'package:dc_store/core/theme/app_text_styles.dart';

/// AddressCard - Displays and allows selection of addresses
///
/// Example usage:
/// ```dart
/// AddressCard(
///   name: 'John Doe',
///   phone: '+880 1234567890',
///   address: '123 Main Street',
///   city: 'Dhaka',
///   isDefault: true,
///   isSelected: selectedId == address.id,
///   onTap: () => selectAddress(address.id),
///   onEdit: () => editAddress(address.id),
///   onDelete: () => deleteAddress(address.id),
/// )
/// ```
class AddressCard extends StatelessWidget {
  /// Recipient name
  final String name;

  /// Phone number
  final String phone;

  /// Street address
  final String address;

  /// City name
  final String city;

  /// Postal code
  final String? postalCode;

  /// Address label (e.g., "Home", "Office")
  final String? label;

  /// Whether this is the default address
  final bool isDefault;

  /// Whether this address is selected (for selection mode)
  final bool isSelected;

  /// Selection mode (shows radio button)
  final bool selectionMode;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback for edit action
  final VoidCallback? onEdit;

  /// Callback for delete action
  final VoidCallback? onDelete;

  /// Callback for set as default action
  final VoidCallback? onSetDefault;

  const AddressCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    this.postalCode,
    this.label,
    this.isDefault = false,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                if (selectionMode) ...[
                  _SelectionIndicator(isSelected: isSelected, isDark: isDark),
                  const SizedBox(width: 12),
                ],

                // Name and label
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (label != null) ...[
                        const SizedBox(width: 8),
                        _LabelBadge(label: label!),
                      ],
                    ],
                  ),
                ),

                // Default badge
                if (isDefault) ...[const SizedBox(width: 8), _DefaultBadge()],
              ],
            ),
            const SizedBox(height: 8),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  phone,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatAddress(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Actions
            if (onEdit != null || onDelete != null || onSetDefault != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onEdit != null)
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: onEdit!,
                      isDark: isDark,
                    ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      onTap: onDelete!,
                      isDark: isDark,
                      isDestructive: true,
                    ),
                  ],
                  const Spacer(),
                  if (onSetDefault != null && !isDefault)
                    _ActionButton(
                      icon: Icons.check_circle_outline,
                      label: 'Set as Default',
                      onTap: onSetDefault!,
                      isDark: isDark,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatAddress() {
    final parts = [address, city];
    if (postalCode != null) parts.add(postalCode!);
    return parts.join(', ');
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isDark;

  const _SelectionIndicator({required this.isSelected, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.primary)
              : (isDark ? AppColors.darkBorder : AppColors.border),
          width: 2,
        ),
        color: isSelected
            ? (isDark ? AppColors.darkPrimary : AppColors.primary)
            : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _LabelBadge extends StatelessWidget {
  final String label;

  const _LabelBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Default',
        style: AppTextStyles.overline.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// Compact address display for checkout
class CompactAddressCard extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback? onTap;

  const CompactAddressCard({
    super.key,
    required this.name,
    required this.address,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.darkTextHint : AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}
