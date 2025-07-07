import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;
  final DateTime? expiresAt;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': user?.toJson(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  // Helper getters
  bool get isSuccess => success;
  bool get hasToken => token != null && token!.isNotEmpty;
  bool get hasUser => user != null;
  bool get isTokenValid =>
      hasToken && (expiresAt == null || expiresAt!.isAfter(DateTime.now()));
}
