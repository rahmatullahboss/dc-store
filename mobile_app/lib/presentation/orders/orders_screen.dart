import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/config/white_label_config.dart';
import '../../features/orders/data/orders_repository.dart';
import '../common/widgets/animated_empty_state.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Completed', 'Cancelled'];

  // Filtered orders based on selection
  List<Order> _getFilteredOrders(List<Order> orders) {
    if (_selectedFilter == 'All') return orders;
    if (_selectedFilter == 'Active') {
      return orders
          .where(
            (o) =>
                o.status == 'processing' ||
                o.status == 'confirmed' ||
                o.status == 'shipped' ||
                o.status == 'pending',
          )
          .toList();
    }
    if (_selectedFilter == 'Completed') {
      return orders.where((o) => o.status == 'delivered').toList();
    }
    if (_selectedFilter == 'Cancelled') {
      return orders.where((o) => o.status == 'cancelled').toList();
    }
    return orders;
  }

  // Convert API status to UI status
  OrderStatus _getOrderStatus(String status) {
    switch (status) {
      case 'processing':
      case 'pending':
      case 'confirmed':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryBlue = WhiteLabelConfig.accentColor;
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final cardColor = isDark ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final subtleTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF616F89);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    // Get filtered orders from API
    final filteredOrders = _getFilteredOrders(ordersState.orders);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                      ),
                      child: Icon(
                        LucideIcons.arrowLeft,
                        size: 20,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Search functionality
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Icon(
                        LucideIcons.search,
                        size: 22,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryBlue : cardColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: isSelected
                                  ? primaryBlue
                                  : (isDark
                                        ? Colors.grey[700]!
                                        : Colors.transparent),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: primaryBlue.withAlpha(51),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : subtleTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Orders List
            Expanded(
              child: ordersState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(ordersProvider.notifier).refresh(),
                      child: filteredOrders.isEmpty
                          ? _buildEmptyState(
                              isDark,
                              textColor,
                              subtleTextColor,
                              primaryBlue,
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = filteredOrders[index];
                                return _buildApiOrderCard(
                                  order,
                                  index,
                                  isDark,
                                  cardColor,
                                  textColor,
                                  subtleTextColor,
                                  borderColor,
                                  primaryBlue,
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiOrderCard(
    Order order,
    int index,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    final status = _getOrderStatus(order.status);
    final isCancelled = status == OrderStatus.cancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: isCancelled ? 0.8 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.formattedDate} • ${order.itemCount} ${order.itemCount == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subtleTextColor,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(status, isDark),
              ],
            ),
            const SizedBox(height: 16),

            // Thumbnails
            Row(
              children: [
                ...order.thumbnails
                    .take(2)
                    .map(
                      (url) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: isCancelled
                                ? const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  )
                                : const ColorFilter.mode(
                                    Colors.transparent,
                                    BlendMode.multiply,
                                  ),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 64,
                                height: 64,
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                if (order.itemCount > order.thumbnails.length)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${order.itemCount - order.thumbnails.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: subtleTextColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.grey[700]!.withAlpha(128)
                        : borderColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: subtleTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                  _buildActionButtons(
                    order,
                    isDark,
                    cardColor,
                    textColor,
                    borderColor,
                    primaryBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.05);
  }

  Widget _buildStatusBadge(OrderStatus status, bool isDark) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.processing:
        bgColor = isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF);
        textColor = isDark
            ? const Color(0xFF60A5FA)
            : WhiteLabelConfig.accentColor;
        label = 'PROCESSING';
        break;
      case OrderStatus.shipped:
        bgColor = isDark ? const Color(0xFF422006) : const Color(0xFFFFF7ED);
        textColor = isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C);
        label = 'SHIPPED';
        break;
      case OrderStatus.delivered:
        bgColor = isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4);
        textColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
        label = 'DELIVERED';
        break;
      case OrderStatus.cancelled:
        bgColor = isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2);
        textColor = isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
        label = 'CANCELLED';
        break;
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    Order order,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    final status = _getOrderStatus(order.status);
    switch (status) {
      case OrderStatus.processing:
      case OrderStatus.shipped:
        return _buildPrimaryButton('Track Order', primaryBlue, () {
          context.push('/track/${order.id}');
        });
      case OrderStatus.delivered:
        return Row(
          children: [
            _buildOutlinedButton(
              'Review',
              isDark,
              textColor,
              borderColor,
              () => context.push('/write-review?orderId=${order.id}'),
            ),
            const SizedBox(width: 8),
            _buildPrimaryButton('Reorder', primaryBlue, () {
              // Navigate to product page for reorder
              context.push('/orders/${order.id}');
            }),
          ],
        );
      case OrderStatus.cancelled:
        return GestureDetector(
          onTap: () => context.push('/orders/${order.id}'),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildPrimaryButton(
    String label,
    Color primaryBlue,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(
    String label,
    bool isDark,
    Color textColor,
    Color borderColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? Colors.grey[700]! : borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    bool isDark,
    Color textColor,
    Color subtleTextColor,
    Color primaryBlue,
  ) {
    return AnimatedEmptyState.orders(onShopNow: () => context.go('/'));
  }
}

enum OrderStatus { processing, shipped, delivered, cancelled }
