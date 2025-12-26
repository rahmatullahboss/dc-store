import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Completed', 'Cancelled'];

  // Mock orders data
  final List<_Order> _orders = [
    _Order(
      id: 'ORD-3920',
      date: 'Oct 24, 2023',
      itemCount: 2,
      status: OrderStatus.processing,
      total: 145.00,
      thumbnails: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2UEbrLQhd-vwHiK759ASCGcKyu4SLgV03OGmzH2svbhK0nrL5bArpC4YZ07hxhGKQddqpjmx-ALcLOEuLhbHLBtmcwg_IuFufWRRNIpXM7S8kxKXYx_inhzmelNAvJwX-uOiaAcu6c6UiDVnozfoXNE-HAcqxFuZzkUyI8RGRRPhK3zYRJz4kz1L2_0fkmp7GsHCJCZdjJ4OVdyg9LNH9KyeHjDl3xrLtnLHmGZM_S_z5keJbNYQPB6IGNW1LcXkqi8JKCauD_Uc',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC943PQNcBYQrxPSzZHM9Z4XDis5F2MGaR4u9QNMKD6019BDL4STVStBdv-ZdmQ6HsPpYWJyHeCQo5u--2SowMAHW080WvAX4x7D1CSAIYIrfb3h7c3TN9-gi5vwDL662QMjnuKztqAnGgH27bmaazy6TbGWnIvS0Rv8sZOKZ5WiDF6IUe5JVUP_JA7--GrueZdgHNqqQrVOjTz5RtRIYLM80gk17JRJfQ_RY9j2uJfqcOsvO1f-YCO87RKZG51RZlwq1G9x_sG3zE',
      ],
    ),
    _Order(
      id: 'ORD-2481',
      date: 'Sept 12, 2023',
      itemCount: 3,
      status: OrderStatus.shipped,
      total: 35.00,
      thumbnails: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDIM_NQnao8xwrc7xLuRTrdy8BFV3CRTcwFL4WBkMkYX5j_2sdWkjx7XrjSS9GFvvBTPFS567gT3uH3EAcUde9HCRJyYl0vTgf4FMEfmsg5E-AB5O_9Bh1-kruMHt0X45FssPuPp4OpQfomSSxFeh_drkIanaUOp-FlibSLflQHS1kcLd2AGf1m3wQf2kjjrLqq7Th7001EN-5oE_bB8hr9cwW0xqaXiZAW-ysked_svknjdjTXjNU6-IkQuO9vui0p_SJQ2Yk3u2E',
      ],
    ),
    _Order(
      id: 'ORD-1156',
      date: 'Aug 05, 2023',
      itemCount: 1,
      status: OrderStatus.delivered,
      total: 299.00,
      thumbnails: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAo8nUru5sJiyboNGtUD4xyw_yX5oDTJ0Lw_9Eb8DKgthrQeUwtEp3pA6lh-SQuQwQ2tZ6-RDaQGs47r_zGHMwhXyMmUOxTJYcOa1zWv6r5vtwI5l0u4KVFuqAJRArplmNG9QH7_6hF-77NN6T4zF8k7nFiySLb4GzXyPBDN4xX4U3VH-ONfqLuhpGPP1ih8VM9KKaNWVyCmRWhVGgsdUaPRq9wG5CqCQs18Ufaz1rw1MsL3KckDWauR9Dltr3ZYpVopt5i7w0FjeE',
      ],
    ),
    _Order(
      id: 'ORD-0922',
      date: 'Jul 12, 2023',
      itemCount: 1,
      status: OrderStatus.cancelled,
      total: 25.00,
      thumbnails: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCq42kRoWsAr6EDn71SZmM0nzfbjUK68fe8TmoyYCXZzH6E0nSmD5xmERBM820jNxtlVgrCwmZvF51acLX6iX3UyFLuKt9YqZ8GhbH0crhJG7EVulroHVlDqblZY0FIoFi6HW1Iz9deUx1s8KgcZLuThEA5bQXVBRtXBNEmctzj6OPQD_QQYXQ-Sbe9GiZOqeI40FDZGjpU2UvBP1IVYvJE7y7ics43cCFMwu5KvPbUudah_6rMNuszPWUM2VUO68sK681VSDjjTjI',
      ],
    ),
  ];

  List<_Order> get _filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    if (_selectedFilter == 'Active') {
      return _orders
          .where(
            (o) =>
                o.status == OrderStatus.processing ||
                o.status == OrderStatus.shipped,
          )
          .toList();
    }
    if (_selectedFilter == 'Completed') {
      return _orders.where((o) => o.status == OrderStatus.delivered).toList();
    }
    if (_selectedFilter == 'Cancelled') {
      return _orders.where((o) => o.status == OrderStatus.cancelled).toList();
    }
    return _orders;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const primaryBlue = Color(0xFF135bec);
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final cardColor = isDark ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final subtleTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF616F89);
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -0.3,
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
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState(
                      isDark,
                      textColor,
                      subtleTextColor,
                      primaryBlue,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(
                          _filteredOrders[index],
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
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    _Order order,
    int index,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtleTextColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    final isCancelled = order.status == OrderStatus.cancelled;

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
                      'Order #${order.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.date} • ${order.itemCount} ${order.itemCount == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subtleTextColor,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(order.status, isDark),
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
        textColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF135bec);
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
    _Order order,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color borderColor,
    Color primaryBlue,
  ) {
    switch (order.status) {
      case OrderStatus.processing:
      case OrderStatus.shipped:
        return _buildPrimaryButton('Track Order', primaryBlue, () {});
      case OrderStatus.delivered:
        return Row(
          children: [
            _buildOutlinedButton(
              'Details',
              isDark,
              textColor,
              borderColor,
              () {},
            ),
            const SizedBox(width: 8),
            _buildPrimaryButton('Reorder', primaryBlue, () {}),
          ],
        );
      case OrderStatus.cancelled:
        return Container(
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: isDark
                        ? primaryBlue.withAlpha(26)
                        : const Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.shoppingBag,
                    size: 64,
                    color: primaryBlue.withAlpha(102),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.orange[400]!.withAlpha(153),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 24,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: primaryBlue.withAlpha(153),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Looks like you haven't placed any orders yet. Start shopping to find great deals!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: subtleTextColor),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => context.go('/'),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Start Shopping',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
      ),
    );
  }
}

enum OrderStatus { processing, shipped, delivered, cancelled }

class _Order {
  final String id;
  final String date;
  final int itemCount;
  final OrderStatus status;
  final double total;
  final List<String> thumbnails;

  _Order({
    required this.id,
    required this.date,
    required this.itemCount,
    required this.status,
    required this.total,
    required this.thumbnails,
  });
}
