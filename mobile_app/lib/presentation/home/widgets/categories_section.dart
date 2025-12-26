import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryItem(
        name: 'All',
        icon: LucideIcons.layoutGrid,
        color: const Color(0xFF6366F1),
      ),
      CategoryItem(
        name: 'Electronics',
        icon: LucideIcons.smartphone,
        color: const Color(0xFF8B5CF6),
      ),
      CategoryItem(
        name: 'Fashion',
        icon: LucideIcons.shirt,
        color: const Color(0xFFEC4899),
      ),
      CategoryItem(
        name: 'Home',
        icon: LucideIcons.home,
        color: const Color(0xFF14B8A6),
      ),
      CategoryItem(
        name: 'Beauty',
        icon: LucideIcons.sparkles,
        color: const Color(0xFFF59E0B),
      ),
      CategoryItem(
        name: 'Sports',
        icon: LucideIcons.dumbbell,
        color: const Color(0xFF10B981),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/products'),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => context.push('/products'),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: category.color.withAlpha(26),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: category.color.withAlpha(51),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({required this.name, required this.icon, required this.color});
}
