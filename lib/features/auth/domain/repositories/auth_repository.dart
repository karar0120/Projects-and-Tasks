import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/features/auth/data/models/login_request.dart';
import 'package:projectsandtasks/features/auth/data/models/login_response.dart';
import 'package:projectsandtasks/features/auth/data/models/register_request.dart';

/// Abstract auth repository (domain layer).
abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
}

/// Result type for auth operations (success or API error).
typedef AuthResult<T> = ({T? data, ApiErrorModel? error});
