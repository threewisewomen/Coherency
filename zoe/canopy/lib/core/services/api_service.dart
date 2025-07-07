import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/auth_response.dart';
import '../config/api_config.dart';

class ApiService {
  // Use the configuration from ApiConfig
  static String get baseUrl => ApiConfig.baseUrl;
  static const Duration timeoutDuration = Duration(seconds: 30);

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Enhanced error handling for .NET backend responses with debugging
  Future<ApiResponse<T>> _handleRequest<T>(
    Future<http.Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      print('🚀 Making API request...');
      final response = await request().timeout(timeoutDuration);

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Headers: ${response.headers}');
      print('📡 Response Body: ${response.body}');

      return _processResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      print('❌ SocketException: ${e.message}');
      return ApiResponse.error(
        'No internet connection. Please check your network.',
        errorCode: 'NETWORK_ERROR',
      );
    } on HttpException catch (e) {
      print('❌ HttpException: ${e.message}');
      return ApiResponse.error(
        'Server communication error. Please try again.',
        errorCode: 'HTTP_ERROR',
      );
    } on FormatException catch (e) {
      print('❌ FormatException: ${e.message}');
      return ApiResponse.error(
        'Invalid response format from server: ${e.message}',
        errorCode: 'FORMAT_ERROR',
      );
    } catch (e) {
      print('❌ Unknown Error: ${e.toString()}');
      return ApiResponse.error(
        'An unexpected error occurred: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  ApiResponse<T> _processResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      print('🔍 Processing response...');

      if (response.body.isEmpty) {
        print('⚠️ Empty response body');
        return ApiResponse.error(
          'Empty response from server',
          errorCode: 'EMPTY_RESPONSE',
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('✅ Parsed JSON: $responseData');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Success response, creating AuthResponse...');
        final result = fromJson(responseData);
        print('✅ AuthResponse created: $result');

        return ApiResponse.success(
          result,
          message: responseData['message'],
        );
      } else {
        // Handle .NET backend error responses
        String errorMessage = responseData['message'] ??
            responseData['title'] ??
            'Request failed';

        print('❌ Error response: $errorMessage');

        return ApiResponse.error(
          errorMessage,
          errorCode:
              responseData['errorCode'] ?? response.statusCode.toString(),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ JSON Parse Error: ${e.toString()}');
      print('❌ Raw response: ${response.body}');

      // If JSON parsing fails, try to get plain text response
      return ApiResponse.error(
        response.body.isNotEmpty ? response.body : 'Unknown server error',
        errorCode: 'PARSE_ERROR',
        statusCode: response.statusCode,
      );
    }
  }

  // Updated login to match your .NET backend DTO
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    final url = '$baseUrl${ApiConfig.loginEndpoint}';
    final body = {
      'email': email,
      'password': password,
    };

    print('🔐 Login Request:');
    print('URL: $url');
    print('Body: $body');
    print('Headers: $_defaultHeaders');

    return _handleRequest(
      () => http.post(
        Uri.parse(url),
        headers: _defaultHeaders,
        body: json.encode(body),
      ),
      (json) {
        print('🔄 Creating AuthResponse from JSON: $json');
        return AuthResponse.fromJson(json);
      },
    );
  }

  // Updated register to match your .NET backend RegisterRequestDto
  Future<ApiResponse<AuthResponse>> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final url = '$baseUrl${ApiConfig.registerEndpoint}';
    final body = {
      'username': username,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };

    print('📝 Register Request:');
    print('URL: $url');
    print('Body: $body');

    return _handleRequest(
      () => http.post(
        Uri.parse(url),
        headers: _defaultHeaders,
        body: json.encode(body),
      ),
      (json) => AuthResponse.fromJson(json),
    );
  }

  // Get user profile (protected endpoint example)
  Future<ApiResponse<Map<String, dynamic>>> getUserProfile(
      String accessToken) async {
    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          ..._defaultHeaders,
          'Authorization': 'Bearer $accessToken',
        },
      ),
      (json) => json,
    );
  }

  // Logout (if you implement it later)
  Future<ApiResponse<bool>> logout(String accessToken) async {
    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiConfig.logoutEndpoint}'),
        headers: {
          ..._defaultHeaders,
          'Authorization': 'Bearer $accessToken',
        },
      ),
      (json) => json['success'] ?? true,
    );
  }

  // Test connection to your backend
  Future<ApiResponse<Map<String, dynamic>>> testConnection() async {
    final url = '$baseUrl/health';
    print('🏥 Testing connection to: $url');

    return _handleRequest(
      () => http.get(
        Uri.parse(url),
        headers: _defaultHeaders,
      ),
      (json) => json,
    );
  }
}
