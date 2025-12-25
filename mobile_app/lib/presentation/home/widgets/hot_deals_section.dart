import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../common/widgets/app_badge.dart';

class HotDealsSection extends StatelessWidget {
  const HotDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final deals = [
      {
        "name": "Flash Sale",
        "discount": "50% OFF",
        "badge": "HOT",
        "icon": LucideIcons.zap,
        "bg": const Color(0xFFFEF2F2), // red-50
        "iconBg": const Color(0xFFEF4444), // red-500
        "color": const Color(0xFFEF4444), // red-500
        "timeLeft": "2h 30m",
      },
      {
        "name": "Buy 2 Get 1",
        "discount": "FREE",
        "badge": "BOGO",
        "icon": LucideIcons.gift,
        "bg": const Color(0xFFFAF5FF), // purple-50
        "iconBg": const Color(0xFFA855F7), // purple-500
        "color": const Color(0xFFA855F7),
        "timeLeft": "5h left",
      },
      {
        "name": "New User",
        "discount": "20% OFF",
        "badge": "NEW",
        "icon": LucideIcons.percent,
        "bg": const Color(0xFFEFF6FF), // blue-50
        "iconBg": const Color(0xFF3B82F6), // blue-500
        "color": const Color(0xFF3B82F6),
        "timeLeft": "Limited",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFBEB), // amber-50
            Color(0xFFFFF1F2), // rose-50
            Color(0xFFFAF5FF), // purple-50
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF59E0B),
                            Color(0xFFF43F5E),
                          ], // amber-500 to rose-500
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.zap,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hot Deals",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Limited time offers",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text("View All"),
                      Icon(LucideIcons.arrowRight, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: deals.map((deal) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: deal["bg"] as Color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: deal["iconBg"] as Color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              deal["icon"] as IconData,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          AppBadge(
                            label: deal["badge"] as String,
                            backgroundColor: deal["color"] as Color,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        deal["name"] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        deal["discount"] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: deal["color"] as Color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            deal["timeLeft"] as String,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
