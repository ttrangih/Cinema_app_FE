// lib/utils/app_config.dart

class AppConfig {
  static const String baseUrl = 'https://cinema-be-2-jsnq.onrender.com/api';
  static const int connectTimeout = 30000; // 30s for Render cold start
  static const int receiveTimeout = 30000;
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
