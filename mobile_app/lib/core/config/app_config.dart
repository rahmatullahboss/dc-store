import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  // Production URL - your live Cloudflare site
  static const String productionUrl = 'https://store.digitalcare.site';

  // Development URL for local testing
  static const String developmentUrl = 'http://localhost:3000';

  static String get baseUrl {
    // For web and production, use the deployed URL
    if (kIsWeb) {
      return productionUrl;
    }
    // For mobile development, use localhost (change as needed)
    return productionUrl; // Using production for now
  }

  // Stripe Configuration
  // NOTE: Replace with your actual Stripe publishable key
  static const String stripePublishableKey =
      'pk_test_51RIIbgP0LJrJ5EamZxvaopbXJNRh6qIIFjFvXPMAJLmZJrKkJzRFd9K6xMD5zKmDzIHIlQbZMDJRZiK9QHQY4Mj600RiL0vvhB';
}
