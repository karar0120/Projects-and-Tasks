import 'package:equatable/equatable.dart';

/// Request body for POST /api/auth/login
class LoginRequest extends Equatable {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  @override
  List<Object?> get props => [username, password];
}
