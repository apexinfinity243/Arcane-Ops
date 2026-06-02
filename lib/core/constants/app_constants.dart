class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.arcane-ops.com';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String messagesCollection = 'messages';
  static const String conversationsCollection = 'conversations';
  static const String verificationCodesCollection = 'verification_codes';

  // Duration
  static const Duration verificationCodeExpiry = Duration(minutes: 10);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int phoneNumberLength = 10;
}
