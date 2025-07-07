// lib/core/config/api_config.dart
class ApiConfig {
  // Base URLs for different environments
  static const String _developmentBaseUrl =
      'http://10.0.2.2:5096/api'; // Android emulator to localhost:5096
  static const String _developmentHttpsUrl =
      'http://10.0.2.2:5096/api'; // Android emulator to localhost:7146 (HTTPS)
  static const String _productionBaseUrl =
      'https://your-production-domain.com/api';

  // Use this for iOS simulator or physical device on same network
  static const String _localNetworkUrl =
      'http://192.168.1.XXX:5096/api'; // Replace XXX with your actual IP
  static const String _localNetworkHttpsUrl =
      'https://192.168.1.XXX:7146/api'; // HTTPS version

  // Current environment - change this based on your needs
  static const Environment currentEnvironment = Environment.development;

  // Get the appropriate base URL
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return _developmentBaseUrl; // Using HTTP for development (easier for testing)
      case Environment.developmentHttps:
        return _developmentHttpsUrl; // Use this if you want HTTPS
      case Environment.production:
        return _productionBaseUrl;
      case Environment.localNetwork:
        return _localNetworkUrl;
    }
  }

  // API endpoints - FIXED: Match your backend exactly (capital A in Auth)
  static const String loginEndpoint = '/Auth/login';
  static const String registerEndpoint = '/Auth/register';
  static const String logoutEndpoint = '/Auth/logout';
  static const String userProfileEndpoint = '/user/profile';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Token refresh settings
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);
}

enum Environment {
  development, // HTTP - Android Emulator
  developmentHttps, // HTTPS - Android Emulator
  production,
  localNetwork, // For physical devices
}
