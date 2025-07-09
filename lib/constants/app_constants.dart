class AppConstants {
  // App Information
  static const String appName = 'SmartFarmer';
  static const String appVersion = '1.0.0';

  // User Roles
  static const String roleFarmer = 'farmer';

  // Database
  static const String databaseName = 'smart_farmer.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String keyLanguage = 'language';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Crop Types
  static const List<String> cropTypes = [
    'Wheat',
    'Rice',
    'Maize',
    'Cotton',
    'Sugarcane',
    'Pulses',
    'Oilseeds',
    'Vegetables',
    'Fruits',
    'Other',
  ];

  // Soil Types
  static const List<String> soilTypes = [
    'Clay',
    'Sandy',
    'Loamy',
    'Silt',
    'Peaty',
    'Chalky',
    'Other',
  ];

  // Crop Lifespan in Days (for AI insights)
  static const Map<String, int> cropLifespan = {
    'Wheat': 120,
    'Rice': 150,
    'Maize': 100,
    'Cotton': 180,
    'Sugarcane': 365,
    'Pulses': 90,
    'Oilseeds': 120,
    'Vegetables': 60,
    'Fruits': 730,
    'Other': 120,
  };

  // Verification Status
  static const String statusPending = 'pending';
  static const String statusVerified = 'verified';
  static const String statusRejected = 'rejected';

  // Image Limits
  static const int maxCropImages = 3;
  static const int maxVerificationImages = 5;

  // Validation Rules
  static const int aadhaarLength = 12;
  static const int pincodeLength = 6;
  static const int phoneLength = 10;

  // AI Insights Messages
  static const List<String> aiInsights = [
    'Optimal time for fertilizer application',
    'Consider irrigation based on soil moisture',
    'Monitor for pest infestation',
    'Prepare for harvesting activities',
    'Weather conditions are favorable for growth',
    'Consider crop rotation for next season',
    'Soil testing recommended for nutrient balance',
    'Harvest timing looks optimal',
    'Consider organic pest control methods',
    'Crop health indicators are positive',
  ];

  // Location Defaults
  static const double defaultLatitude = 20.5937;
  static const double defaultLongitude = 78.9629;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Supported Languages
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'nativeName': 'English'},
    'hi': {'name': 'Hindi', 'nativeName': 'हिन्दी'},
    'mr': {'name': 'Marathi', 'nativeName': 'मराठी'},
  };
}
