import 'package:equatable/equatable.dart';

/// Request body for POST /api/auth/register
class RegisterRequest extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [username, email, password];
}
