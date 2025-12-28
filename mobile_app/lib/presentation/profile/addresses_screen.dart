import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../core/config/white_label_config.dart';
import '../../data/address_repository.dart';
import '../../data/models/address/address_model.dart';

/// Address Type Enum
enum AddressType { home, office, other }

/// Address Model
class Address {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final AddressType type;
  final bool isDefault;

  const Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'Bangladesh',
    this.type = AddressType.home,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    AddressType? type,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  static const int _maxAddresses = 5;

  List<Address> _addresses = [
    const Address(
      id: '1',
      name: 'John Doe',
      phone: '+880 1234567890',
      addressLine1: '123 Maple Avenue, Apt 4B',
      city: 'Dhaka',
      state: 'Dhaka Division',
      zipCode: '1205',
      type: AddressType.home,
      isDefault: true,
    ),
    const Address(
      id: '2',
      name: 'John Doe',
      phone: '+880 9876543210',
      addressLine1: 'Tech Park, Building C, Floor 5',
      addressLine2: '456 Innovation Blvd',
      city: 'Chittagong',
      state: 'Chittagong Division',
      zipCode: '4000',
      type: AddressType.office,
      isDefault: false,
    ),
    const Address(
      id: '3',
      name: 'Jane Doe',
      phone: '+880 1111111111',
      addressLine1: '789 Country Road',
      city: 'Sylhet',
      state: 'Sylhet Division',
      zipCode: '3100',
      type: AddressType.other,
      isDefault: false,
    ),
  ];

  void _showAddEditSheet({Address? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddEditAddressSheet(
        address: address,
        onSave: (newAddress) {
          setState(() {
            if (address != null) {
              // Edit existing
              final index = _addresses.indexWhere((a) => a.id == address.id);
              if (index != -1) {
                _addresses[index] = newAddress;
              }
            } else {
              // Add new
              _addresses.add(newAddress);
            }
            // Handle default
            if (newAddress.isDefault) {
              _addresses = _addresses.map((a) {
                return a.id == newAddress.id ? a : a.copyWith(isDefault: false);
              }).toList();
            }
          });
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text(address != null ? 'Address updated' : 'Address added'),
            autoCloseDuration: const Duration(seconds: 2),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(Address address) {
    showDialog(
      context: context,
      builder: (context) => _DeleteConfirmationDialog(
        onConfirm: () {
          setState(() {
            _addresses.removeWhere((a) => a.id == address.id);
            // If deleted was default, make first one default
            if (address.isDefault && _addresses.isNotEmpty) {
              _addresses[0] = _addresses[0].copyWith(isDefault: true);
            }
          });
          Navigator.pop(context);
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: const Text('Address deleted'),
            autoCloseDuration: const Duration(seconds: 2),
          );
        },
      ),
    );
  }

  void _setAsDefault(Address address) {
    setState(() {
      _addresses = _addresses.map((a) {
        return a.copyWith(isDefault: a.id == address.id);
      }).toList();
    });
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: const Text('Default address updated'),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF101622)
        : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subtleTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: textColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Addresses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_addresses.length < _maxAddresses)
            TextButton(
              onPressed: () => _showAddEditSheet(),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: WhiteLabelConfig.accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState(textColor, subtleTextColor)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _addresses.length + 1, // +1 for count indicator
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == _addresses.length) {
                        // Address count indicator
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${_addresses.length} of $_maxAddresses addresses used',
                              style: TextStyle(
                                fontSize: 12,
                                color: subtleTextColor.withAlpha(150),
                              ),
                            ),
                          ),
                        );
                      }
                      return _buildAddressCard(
                        _addresses[index],
                        index,
                        isDark,
                        surfaceColor,
                        textColor,
                        subtleTextColor,
                        borderColor,
                      );
                    },
                  ),
          ),
          // Sticky Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addresses.length < _maxAddresses
                      ? () => _showAddEditSheet()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(LucideIcons.plus, size: 20),
                  label: const Text(
                    'Add New Address',
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

  Widget _buildEmptyState(Color textColor, Color subtleTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.mapPin,
            size: 64,
            color: subtleTextColor.withAlpha(100),
          ),
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
            'Add your first delivery address',
            style: TextStyle(fontSize: 14, color: subtleTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    Address address,
    int index,
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    final typeIcon = _getTypeIcon(address.type);
    final typeColor = _getTypeColor(address.type);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: typeColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(typeIcon, size: 16, color: typeColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _getTypeName(address.type),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
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
                          color: const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: WhiteLabelConfig.accentColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: Icon(
                        LucideIcons.moreVertical,
                        color: subtleTextColor,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        if (!address.isDefault)
                          const PopupMenuItem(
                            value: 'default',
                            child: Text('Set as Default'),
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showAddEditSheet(address: address);
                            break;
                          case 'delete':
                            _showDeleteDialog(address);
                            break;
                          case 'default':
                            _setAsDefault(address);
                            break;
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Details
                Padding(
                  padding: const EdgeInsets.only(left: 42),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${address.addressLine1}${address.addressLine2.isNotEmpty ? '\n${address.addressLine2}' : ''}\n${address.city}, ${address.state} ${address.zipCode}\n${address.country}',
                        style: TextStyle(
                          fontSize: 13,
                          color: subtleTextColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phone: ${address.phone}',
                        style: TextStyle(fontSize: 13, color: subtleTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor.withAlpha(100)),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 42),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showAddEditSheet(address: address),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.edit3,
                              size: 14,
                              color: WhiteLabelConfig.accentColor,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: WhiteLabelConfig.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        color: borderColor,
                      ),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(address),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.trash2,
                              size: 14,
                              color: subtleTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: subtleTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (!address.isDefault)
                  GestureDetector(
                    onTap: () => _setAsDefault(address),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Set as Default',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subtleTextColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.05);
  }

  IconData _getTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return LucideIcons.home;
      case AddressType.office:
        return LucideIcons.briefcase;
      case AddressType.other:
        return LucideIcons.mapPin;
    }
  }

  Color _getTypeColor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return WhiteLabelConfig.accentColor;
      case AddressType.office:
        return Colors.orange;
      case AddressType.other:
        return Colors.purple;
    }
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

// ═══════════════════════════════════════════════════════════════
// ADD/EDIT ADDRESS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════

class _AddEditAddressSheet extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  const _AddEditAddressSheet({this.address, required this.onSave});

  @override
  State<_AddEditAddressSheet> createState() => _AddEditAddressSheetState();
}

class _AddEditAddressSheetState extends State<_AddEditAddressSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _zipController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _addressController;
  AddressType _selectedType = AddressType.home;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _nameController = TextEditingController(text: a?.name ?? '');
    _phoneController = TextEditingController(
      text: a?.phone.replaceFirst('+880 ', '') ?? '',
    );
    _zipController = TextEditingController(text: a?.zipCode ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _stateController = TextEditingController(text: a?.state ?? '');
    _addressController = TextEditingController(text: a?.addressLine1 ?? '');
    _selectedType = a?.type ?? AddressType.home;
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text('Please fill all required fields'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }

    final newAddress = Address(
      id:
          widget.address?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      phone: '+880 ${_phoneController.text}',
      addressLine1: _addressController.text,
      city: _cityController.text,
      state: _stateController.text.isNotEmpty
          ? _stateController.text
          : _cityController.text,
      zipCode: _zipController.text,
      type: _selectedType,
      isDefault: _isDefault,
    );

    widget.onSave(newAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subtleTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF6B7280);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE5E7EB);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.address != null ? 'Edit Address' : 'Add Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x, color: subtleTextColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  _buildField(
                    'Full Name',
                    _nameController,
                    'John Doe',
                    inputBg,
                    textColor,
                    subtleTextColor,
                    borderColor,
                  ),
                  const SizedBox(height: 20),
                  // Phone
                  _buildLabel('Phone Number', textColor),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFF3F4F6),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          '+880',
                          style: TextStyle(
                            color: subtleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '1234567890',
                            hintStyle: TextStyle(
                              color: subtleTextColor.withAlpha(150),
                            ),
                            filled: true,
                            fillColor: inputBg,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(12),
                              ),
                              borderSide: const BorderSide(
                                color: WhiteLabelConfig.accentColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Zip & City
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          'Zip Code',
                          _zipController,
                          '1205',
                          inputBg,
                          textColor,
                          subtleTextColor,
                          borderColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          'City',
                          _cityController,
                          'Dhaka',
                          inputBg,
                          textColor,
                          subtleTextColor,
                          borderColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // State & Country
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          'State/Division',
                          _stateController,
                          'Dhaka Division',
                          inputBg,
                          textColor,
                          subtleTextColor,
                          borderColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Country', textColor),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF374151)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                'Bangladesh',
                                style: TextStyle(
                                  color: subtleTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Address Line
                  _buildField(
                    'Address Line',
                    _addressController,
                    'Street address, apartment, suite, etc.',
                    inputBg,
                    textColor,
                    subtleTextColor,
                    borderColor,
                  ),
                  const SizedBox(height: 24),
                  // Address Type
                  _buildLabel('Address Type', textColor),
                  const SizedBox(height: 10),
                  Row(
                    children: AddressType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = type),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: type == AddressType.home ? 0 : 8,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? WhiteLabelConfig.accentColor
                                    : borderColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              type == AddressType.home
                                  ? 'Home'
                                  : type == AddressType.office
                                  ? 'Office'
                                  : 'Other',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? WhiteLabelConfig.accentColor
                                    : textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Default Checkbox
                  GestureDetector(
                    onTap: () => setState(() => _isDefault = !_isDefault),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _isDefault
                                ? WhiteLabelConfig.accentColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _isDefault
                                  ? WhiteLabelConfig.accentColor
                                  : borderColor,
                              width: 2,
                            ),
                          ),
                          child: _isDefault
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Set as default address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.black,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, Color textColor) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint,
    Color inputBg,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, textColor),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subtleTextColor.withAlpha(150)),
            filled: true,
            fillColor: inputBg,
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
              borderSide: const BorderSide(color: WhiteLabelConfig.accentColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DELETE CONFIRMATION DIALOG
// ═══════════════════════════════════════════════════════════════

class _DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.alertTriangle,
                color: Color(0xFFDC2626),
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete Address?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete this address? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
