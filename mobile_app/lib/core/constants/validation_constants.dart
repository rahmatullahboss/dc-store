/// Validation Constants
/// Regex patterns, min/max lengths, and validation error messages
class ValidationConstants {
  ValidationConstants._();

  // ═══════════════════════════════════════════════════════════════
  // REGEX PATTERNS
  // ═══════════════════════════════════════════════════════════════

  /// Email validation pattern
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Bangladesh phone number pattern (01X-XXXXXXXX)
  static final RegExp bdPhonePattern = RegExp(r'^01[3-9]\d{8}$');

  /// General phone pattern (10-15 digits)
  static final RegExp phonePattern = RegExp(r'^\+?\d{10,15}$');

  /// Password pattern (min 8 chars, 1 uppercase, 1 lowercase, 1 digit)
  static final RegExp strongPasswordPattern = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );

  /// Simple password pattern (min 6 chars, alphanumeric)
  static final RegExp simplePasswordPattern = RegExp(r'^[a-zA-Z0-9]{6,}$');

  /// Name pattern (letters, spaces, some special chars)
  static final RegExp namePattern = RegExp(r"^[a-zA-Z\s\-'.]+$");

  /// Bengali name pattern
  static final RegExp bengaliNamePattern = RegExp(r'^[\u0980-\u09FF\s]+$');

  /// Alpha numeric pattern
  static final RegExp alphaNumericPattern = RegExp(r'^[a-zA-Z0-9]+$');

  /// Numeric only pattern
  static final RegExp numericPattern = RegExp(r'^[0-9]+$');

  /// Price pattern (decimal number)
  static final RegExp pricePattern = RegExp(r'^\d+(\.\d{1,2})?$');

  /// Postal code pattern (Bangladesh - 4 digits)
  static final RegExp postalCodePattern = RegExp(r'^\d{4}$');

  /// URL pattern
  static final RegExp urlPattern = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  /// Coupon code pattern (alphanumeric, uppercase)
  static final RegExp couponPattern = RegExp(r'^[A-Z0-9]{4,20}$');

  // ═══════════════════════════════════════════════════════════════
  // LENGTH CONSTRAINTS
  // ═══════════════════════════════════════════════════════════════

  // Name
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Email
  static const int minEmailLength = 5;
  static const int maxEmailLength = 100;

  // Password
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Phone
  static const int phoneLength = 11;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // Address
  static const int minAddressLength = 10;
  static const int maxAddressLength = 200;

  // Review
  static const int minReviewLength = 10;
  static const int maxReviewLength = 500;

  // Search
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;

  // Product
  static const int minProductNameLength = 3;
  static const int maxProductNameLength = 150;
  static const int maxProductDescLength = 2000;

  // OTP
  static const int otpLength = 6;

  // Pin
  static const int pinLength = 4;

  // ═══════════════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ═══════════════════════════════════════════════════════════════

  // Required Fields
  static const String requiredField = 'This field is required';
  static const String requiredEmail = 'Email is required';
  static const String requiredPassword = 'Password is required';
  static const String requiredName = 'Name is required';
  static const String requiredPhone = 'Phone number is required';
  static const String requiredAddress = 'Address is required';

  // Invalid Format
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword =
      'Password must be at least 6 characters';
  static const String invalidStrongPassword =
      'Password must contain uppercase, lowercase, and number';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidBdPhone =
      'Please enter a valid BD phone number (01X-XXXXXXXX)';
  static const String invalidName = 'Please enter a valid name';
  static const String invalidUrl = 'Please enter a valid URL';
  static const String invalidPostalCode = 'Please enter a valid postal code';
  static const String invalidCoupon = 'Please enter a valid coupon code';
  static const String invalidOtp = 'Please enter a valid OTP';

  // Length Errors
  static const String nameTooShort =
      'Name must be at least $minNameLength characters';
  static const String nameTooLong =
      'Name cannot exceed $maxNameLength characters';
  static const String passwordTooShort =
      'Password must be at least $minPasswordLength characters';
  static const String addressTooShort =
      'Address must be at least $minAddressLength characters';
  static const String reviewTooShort =
      'Review must be at least $minReviewLength characters';

  // Password Match
  static const String passwordMismatch = 'Passwords do not match';
  static const String confirmPasswordRequired = 'Please confirm your password';

  // Terms
  static const String termsRequired = 'Please accept the terms and conditions';
}
