/// Animation Duration Constants for consistent animations
class AppAnimations {
  AppAnimations._();

  // ═══════════════════════════════════════════════════════════════
  // DURATION VALUES
  // ═══════════════════════════════════════════════════════════════

  /// Instant (no animation)
  static const Duration instant = Duration.zero;

  /// Ultra fast animation (50ms) - for micro-interactions
  static const Duration ultraFast = Duration(milliseconds: 50);

  /// Fast animation (100ms) - for quick feedback
  static const Duration fast = Duration(milliseconds: 100);

  /// Normal animation (200ms) - default for most animations
  static const Duration normal = Duration(milliseconds: 200);

  /// Slow animation (300ms) - for emphasis
  static const Duration slow = Duration(milliseconds: 300);

  /// Slower animation (400ms) - for page transitions
  static const Duration slower = Duration(milliseconds: 400);

  /// Slowest animation (500ms) - for complex animations
  static const Duration slowest = Duration(milliseconds: 500);

  /// Extra slow (600ms) - for dramatic effect
  static const Duration extraSlow = Duration(milliseconds: 600);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC DURATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Button press/hover feedback
  static const Duration buttonFeedback = fast;

  /// Fade in/out animations
  static const Duration fade = normal;

  /// Scale animations
  static const Duration scale = normal;

  /// Page transitions
  static const Duration pageTransition = slower;

  /// Modal/Bottom sheet animations
  static const Duration modal = slow;

  /// Shimmer animation cycle
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Loading indicator cycle
  static const Duration loading = Duration(milliseconds: 1200);

  /// Toast/Snackbar auto-dismiss
  static const Duration toast = Duration(seconds: 3);

  /// Splash screen minimum display
  static const Duration splash = Duration(seconds: 2);

  // ═══════════════════════════════════════════════════════════════
  // DELAY VALUES
  // ═══════════════════════════════════════════════════════════════

  /// Stagger delay between list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Debounce delay for search input
  static const Duration debounce = Duration(milliseconds: 300);

  /// Throttle delay
  static const Duration throttle = Duration(milliseconds: 500);
}
