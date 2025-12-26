import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/external_launcher_service.dart';
import '../../core/config/white_label_config.dart';

/// FAQ Item model
class FAQItem {
  final String id;
  final String question;
  final String answer;
  final IconData icon;
  bool isExpanded;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.icon,
    this.isExpanded = false,
  });
}

/// Support Ticket model
class SupportTicket {
  final String id;
  final String title;
  final String product;
  final String status;
  final String statusColor;
  final String updatedAt;
  final String? imageUrl;

  const SupportTicket({
    required this.id,
    required this.title,
    required this.product,
    required this.status,
    required this.statusColor,
    required this.updatedAt,
    this.imageUrl,
  });
}

/// Help & Support Screen
/// Features: Search bar, Recent ticket, Quick actions grid,
/// Expandable FAQ accordions, Support hours footer
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mock recent ticket
  final SupportTicket _recentTicket = const SupportTicket(
    id: '8291',
    title: 'Refund Request #8291',
    product: 'Smart Watch Series 5',
    status: 'Pending Agent',
    statusColor: 'orange',
    updatedAt: '2h ago',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCppDnbzbciPFqq5hM73peMP6zDcMqBWYW02a8HwxJuI326AFWKGcYptwt4GtBo6Uyp5Rs42DvbWHq2_0EpuD8fban_NWiX4h8FNC8BHkk9T8nqXgXKbOggp_wsuwoe7MDqkj2PNNDnsP3q0XSnrpgB8Cgj8SsZ2Y_ks-DUhGY127kIWG05zkwa1TvrkKC11GdCXkodRTPR5vYZdJsyJGhyMECW1RQaWc1XJP3cGq4LKW39XI9Fp5adCJBWgGFL9y7KylMcFtegzJM',
  );

  // Mock FAQ items
  late List<FAQItem> _faqItems;

  @override
  void initState() {
    super.initState();
    _faqItems = [
      FAQItem(
        id: '1',
        question: 'Where is my order?',
        answer:
            'You can track your order status in the "My Orders" section of your account. Tracking information is updated within 24 hours of shipment.',
        icon: LucideIcons.truck,
      ),
      FAQItem(
        id: '2',
        question: 'How do I return an item?',
        answer:
            'Go to "My Orders", select the item you wish to return, and tap "Request Return". Follow the instructions to print your shipping label.',
        icon: LucideIcons.packageCheck,
      ),
      FAQItem(
        id: '3',
        question: 'Payment methods accepted',
        answer:
            'We accept all major credit cards (Visa, MasterCard, Amex), PayPal, and Apple Pay.',
        icon: LucideIcons.creditCard,
      ),
      FAQItem(
        id: '4',
        question: 'Change Account Password',
        answer:
            'Navigate to Settings > Security > Change Password. You will need to verify your email to complete the process.',
        icon: LucideIcons.user,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFAQ(int index) {
    setState(() {
      _faqItems[index].isExpanded = !_faqItems[index].isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme colors matching the HTML design
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1a2233) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0d121b);
    final subtleColor = isDark
        ? const Color(0xFF94a3b8)
        : const Color(0xFF4c669a);
    final borderColor = isDark
        ? const Color(0xFF2a3344)
        : const Color(0xFFe5e7eb);
    const primaryColor = Color(0xFF135bec);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: surfaceColor.withAlpha(242),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(LucideIcons.arrowLeft, color: textColor, size: 24),
            ),
            centerTitle: true,
            title: Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: -0.3,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: borderColor),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                _buildHeroSection(
                  isDark: isDark,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),

                // Recent Ticket Section
                _buildRecentTicketSection(
                  isDark: isDark,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),

                // Quick Actions Grid
                _buildQuickActionsSection(
                  isDark: isDark,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),

                // FAQ Section
                _buildFAQSection(
                  isDark: isDark,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),

                // Footer
                _buildFooter(
                  isDark: isDark,
                  textColor: textColor,
                  subtleColor: subtleColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection({
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'How can we help you today?',
            style: TextStyle(fontSize: 14, color: subtleColor),
          ),
          const SizedBox(height: 20),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                hintText: 'Search for issues, topics...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: subtleColor.withAlpha(153),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    LucideIcons.search,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 52,
                  minHeight: 48,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTicketSection({
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Ticket',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton(
                onPressed: () => _showAllTickets(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ticket Card
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[700]
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                          image: _recentTicket.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_recentTicket.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _recentTicket.imageUrl == null
                            ? Icon(
                                LucideIcons.package,
                                color: subtleColor,
                                size: 28,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _recentTicket.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _recentTicket.product,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subtleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  LucideIcons.chevronRight,
                                  color: subtleColor.withAlpha(153),
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFFF59E0B).withAlpha(51)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFF59E0B,
                                      ).withAlpha(26),
                                    ),
                                  ),
                                  child: Text(
                                    _recentTicket.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? const Color(0xFFFCD34D)
                                          : const Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Updated ${_recentTicket.updatedAt}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: subtleColor.withAlpha(153),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection({
    required bool isDark,
    required Color textColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildQuickActionCard(
                icon: LucideIcons.messageCircle,
                label: 'Chat with us',
                isDark: isDark,
                textColor: textColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
                onTap: () => _launchChat(context),
              ),
              _buildQuickActionCard(
                icon: LucideIcons.phone,
                label: 'Call Support',
                isDark: isDark,
                textColor: textColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
                onTap: () => _launchPhone(context),
              ),
              _buildQuickActionCard(
                icon: LucideIcons.mail,
                label: 'Email Us',
                isDark: isDark,
                textColor: textColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
                onTap: () => _launchEmail(context),
              ),
              _buildQuickActionCard(
                icon: LucideIcons.messagesSquare,
                label: 'WhatsApp',
                isDark: isDark,
                textColor: textColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
                onTap: () => _launchWhatsApp(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color textColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection({
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Topics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_faqItems.length, (index) {
            final item = _faqItems[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _faqItems.length - 1 ? 12 : 0,
              ),
              child: _buildFAQItem(
                item: item,
                index: index,
                isDark: isDark,
                textColor: textColor,
                subtleColor: subtleColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required FAQItem item,
    required int index,
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _toggleFAQ(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(item.icon, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: item.isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        LucideIcons.chevronDown,
                        color: subtleColor.withAlpha(153),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor.withAlpha(128), width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtleColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Was this helpful?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: subtleColor.withAlpha(153),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildFeedbackButton(
                        icon: LucideIcons.thumbsUp,
                        isDark: isDark,
                        subtleColor: subtleColor,
                      ),
                      const SizedBox(width: 8),
                      _buildFeedbackButton(
                        icon: LucideIcons.thumbsDown,
                        isDark: isDark,
                        subtleColor: subtleColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: item.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton({
    required IconData icon,
    required bool isDark,
    required Color subtleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _submitFeedback(context, true),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: subtleColor.withAlpha(153)),
        ),
      ),
    );
  }

  Widget _buildFooter({
    required bool isDark,
    required Color textColor,
    required Color subtleColor,
    required Color surfaceColor,
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isDark
            ? surfaceColor.withAlpha(77)
            : Colors.white.withAlpha(128),
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.clock, size: 16, color: subtleColor),
              const SizedBox(width: 8),
              Text(
                'SUPPORT HOURS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: subtleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Mon - Fri, 9am - 6pm EST',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Typical response time: < 5 minutes',
            style: TextStyle(fontSize: 12, color: subtleColor),
          ),
        ],
      ),
    );
  }

  // Helper methods for launching support channels
  void _showAllTickets(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Support tickets feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _launchChat(BuildContext context) async {
    final launcher = ExternalLauncherService.instance;
    final result = await launcher.launchLiveChat();

    if (!result.success && context.mounted) {
      _showSnackBar(
        context,
        result.fallbackAction ??
            result.errorMessage ??
            'Could not launch live chat',
      );
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final launcher = ExternalLauncherService.instance;
    final result = await launcher.launchPhone();

    if (!result.success && context.mounted) {
      _showSnackBar(
        context,
        result.fallbackAction ?? result.errorMessage ?? 'Could not open phone',
      );
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final launcher = ExternalLauncherService.instance;
    final result = await launcher.launchEmail();

    if (!result.success && context.mounted) {
      _showSnackBar(
        context,
        result.fallbackAction ?? result.errorMessage ?? 'Could not open email',
      );
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final launcher = ExternalLauncherService.instance;
    final result = await launcher.launchWhatsApp();

    if (!result.success && context.mounted) {
      _showSnackBar(
        context,
        result.fallbackAction ??
            result.errorMessage ??
            'Could not open WhatsApp',
      );
    }
  }

  void _submitFeedback(BuildContext context, bool isHelpful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHelpful
              ? 'Thanks for your feedback! 👍'
              : 'We\'ll improve this answer 📝',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isHelpful ? Colors.green : Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
