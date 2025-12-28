# 🎨 UI/UX Guidelines

## Design System

### Colors (from WhiteLabelConfig)

```dart
// lib/config/white_label_config.dart
class WhiteLabelConfig {
  static const Color accentColor = Color(0xFF6366F1); // Primary brand color
  static const Color secondaryColor = Color(0xFF8B5CF6);

  // Use theme colors, not hardcoded values
  static const successColor = Color(0xFF10B981);
  static const errorColor = Color(0xFFEF4444);
  static const warningColor = Color(0xFFF59E0B);
}
```

### Typography

```dart
// Use Google Fonts (Inter is default)
Text(
  'Product Name',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
  ),
)
```

### Spacing

```dart
// Use ScreenUtil for responsive spacing
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox(height: 16.h) // Responsive height
Padding(padding: EdgeInsets.all(16.w)) // Responsive padding
EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
```

## Responsive Design

### ScreenUtil Setup

```dart
// In main.dart
ScreenUtilInit(
  designSize: const Size(375, 812), // iPhone X base
  minTextAdapt: true,
  builder: (context, child) => MaterialApp(...),
)
```

### Responsive Values

```dart
// Font sizes
Text('Title', style: TextStyle(fontSize: 24.sp));

// Dimensions
Container(
  width: 100.w,   // Responsive width
  height: 100.h,  // Responsive height
  padding: EdgeInsets.all(16.r), // Responsive radius
)

// Border radius
BorderRadius.circular(12.r)
```

## Component Patterns

### Product Card

```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with caching
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => ShimmerBox(height: 150.h),
                errorWidget: (_, __, ___) => PlaceholderImage(),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '৳${product.price}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: WhiteLabelConfig.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Loading Skeleton (Shimmer)

```dart
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
```

### Error Widget

```dart
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.alertCircle,
              size: 48.sp,
              color: WhiteLabelConfig.errorColor,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('আবার চেষ্টা করুন'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Empty State

```dart
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = LucideIcons.inbox,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: 24.h),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

## Animation Guidelines

### Use flutter_animate

```dart
import 'package:flutter_animate/flutter_animate.dart';

// Fade in
Widget().animate().fadeIn(duration: 300.ms);

// Slide up with fade
Widget()
  .animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.1, end: 0);

// Staggered list
ListView.builder(
  itemBuilder: (_, i) => Widget()
    .animate(delay: (i * 50).ms)
    .fadeIn()
    .slideX(begin: -0.1, end: 0),
)
```

### Hero Animations

```dart
// In list view
Hero(
  tag: 'product-${product.id}',
  child: CachedNetworkImage(imageUrl: product.imageUrl),
)

// In detail page
Hero(
  tag: 'product-${product.id}',
  child: CachedNetworkImage(imageUrl: product.imageUrl),
)
```

## Accessibility

- Minimum touch target: 48x48
- Use Semantics for screen readers
- Proper contrast ratios
- Keyboard navigation support

```dart
Semantics(
  label: 'Add ${product.name} to cart',
  button: true,
  child: IconButton(
    icon: const Icon(LucideIcons.shoppingCart),
    onPressed: onAddToCart,
  ),
)
```
