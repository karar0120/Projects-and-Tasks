import 'package:equatable/equatable.dart';

/// Response from POST /api/auth/login
/// Example: { "token": "...", "name": "testuser", "email": "test@8com.com", "message": "Login successful" }
class LoginResponse extends Equatable {
  final String token;
  final String name;
  final String email;
  final String? message;

  const LoginResponse({
    required this.token,
    required this.name,
    required this.email,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, name, email, message];
}
