class ApiEndpoints {
  // Base URL
  static const String baseUrl =
      'https://animetower-backend.7modo.com/api/v1'; // Remove trailing slash

  // Auth Endpoints
  static const String login = '/accounts/login'; // Verify this matches your API
  static const String register = '/accounts/register';
  static const String logout = '/accounts/logout';

  // User Endpoints
  static const String profile = '/accounts/profile';
  static const String avatar = '/accounts/avatar';

  static const String genre = '/genres';
  
}
