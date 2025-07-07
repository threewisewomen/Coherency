import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _user != null;

  // Beautiful state management with smooth transitions
  void _setState(AuthState newState, {String? error}) {
    print('🔄 AuthProvider State Change: $_state -> $newState');
    if (error != null) print('❌ Error: $error');

    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    print('⏳ Loading: $loading');
    _isLoading = loading;
    notifyListeners();
  }

  // Initialize authentication state
  Future<void> initializeAuth() async {
    print('🚀 Initializing authentication...');
    _setState(AuthState.loading);

    try {
      final isTokenValid = await SecureStorageService.isTokenValid();
      final user = await SecureStorageService.getUser();

      print('🔐 Token valid: $isTokenValid');
      print('👤 User exists: ${user != null}');

      if (isTokenValid && user != null) {
        _user = user;
        _setState(AuthState.authenticated);
        print('✅ User authenticated: ${user.username}');
      } else {
        await SecureStorageService.clearAll();
        _setState(AuthState.unauthenticated);
        print('❌ User not authenticated');
      }
    } catch (e) {
      print('❌ Auth initialization error: $e');
      _setState(AuthState.error, error: 'Failed to initialize authentication');
    }
  }

  // Beautiful login with comprehensive error handling
  Future<bool> login(String email, String password) async {
    print('🔐 Starting login for: $email');
    _setLoading(true);
    _setState(AuthState.loading);

    try {
      print('📡 Calling API service login...');
      final response = await _apiService.login(email, password);

      print('📨 API Response received:');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');

      if (response.success && response.data != null) {
        final authResponse = response.data!;
        print('🔍 AuthResponse details:');
        print('Success: ${authResponse.success}');
        print('Message: ${authResponse.message}');
        print('Has Token: ${authResponse.hasToken}');
        print('Has User: ${authResponse.hasUser}');
        print('Token: ${authResponse.token?.substring(0, 50)}...');

        if (authResponse.isSuccess &&
            authResponse.hasToken &&
            authResponse.hasUser) {
          print('✅ Login successful, saving data...');

          // Save token and user data securely
          await SecureStorageService.saveToken(
            accessToken: authResponse.token!,
            expiresAt: authResponse.expiresAt ??
                DateTime.now().add(const Duration(hours: 24)),
          );
          await SecureStorageService.saveUser(authResponse.user!);

          _user = authResponse.user!;
          _setState(AuthState.authenticated);
          _setLoading(false);

          print('🎉 Login complete for user: ${_user!.username}');
          return true;
        } else {
          print('❌ Auth response validation failed');
          _setState(AuthState.error, error: authResponse.message);
          _setLoading(false);
          return false;
        }
      } else {
        print('❌ API response failed');
        _setState(AuthState.error, error: response.message ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('❌ Login exception: $e');
      _setState(AuthState.error,
          error: 'Network error occurred. Please check your connection.');
      _setLoading(false);
      return false;
    }
  }

  // Register functionality updated for .NET backend
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    print('📝 Starting registration for: $email');
    _setLoading(true);
    _setState(AuthState.loading);

    try {
      final response = await _apiService.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      print('📨 Register API Response: ${response.success}');

      if (response.success && response.data != null) {
        final authResponse = response.data!;

        if (authResponse.isSuccess) {
          print('✅ Registration successful');
          _setState(AuthState.unauthenticated);
          _setLoading(false);
          return true;
        } else {
          print('❌ Registration failed: ${authResponse.message}');
          _setState(AuthState.error, error: authResponse.message);
          _setLoading(false);
          return false;
        }
      } else {
        print('❌ Registration API failed: ${response.message}');
        _setState(AuthState.error,
            error: response.message ?? 'Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('❌ Registration exception: $e');
      _setState(AuthState.error,
          error: 'Network error occurred. Please check your connection.');
      _setLoading(false);
      return false;
    }
  }

  // Logout with cleanup
  Future<void> logout() async {
    print('🚪 Logging out...');
    _setLoading(true);

    try {
      final accessToken = await SecureStorageService.getAccessToken();
      if (accessToken != null) {
        print('📡 Calling logout API...');
        await _apiService.logout(accessToken);
      }
    } catch (e) {
      print('⚠️ Logout API call failed: $e (continuing anyway)');
    }

    await SecureStorageService.clearAll();
    _user = null;
    _setState(AuthState.unauthenticated);
    _setLoading(false);
    print('✅ Logout complete');
  }

  // Clear error state
  void clearError() {
    print('🧹 Clearing error state');
    if (_state == AuthState.error) {
      _setState(AuthState.unauthenticated);
    }
    _errorMessage = null;
    notifyListeners();
  }

  // Get current access token
  Future<String?> getAccessToken() async {
    return await SecureStorageService.getAccessToken();
  }

  // Check if token is still valid
  Future<bool> isTokenValid() async {
    return await SecureStorageService.isTokenValid();
  }
}
