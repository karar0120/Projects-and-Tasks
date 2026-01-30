import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:projectsandtasks/features/auth/data/models/login_request.dart';
import 'package:projectsandtasks/features/auth/data/models/login_response.dart';
import 'package:projectsandtasks/features/auth/data/models/register_request.dart';
import 'package:projectsandtasks/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository]. Delegates to [AuthRemoteDataSource].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remote = remoteDataSource ?? AuthRemoteDataSourceImpl();

  final AuthRemoteDataSource _remote;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final result = await _remote.login(request);
    return result.fold(
      (error) => throw AuthException(error),
      (response) => response,
    );
  }

  @override
  Future<void> register(RegisterRequest request) async {
    final result = await _remote.register(request);
    result.fold(
      (error) => throw AuthException(error),
      (_) => null,
    );
  }
}

/// Thrown when an auth API call fails. Wraps [ApiErrorModel].
class AuthException implements Exception {
  AuthException(this.apiError);
  final ApiErrorModel apiError;
  /// User-friendly message including validation errors (e.g. password/email rules).
  String get message => apiError.displayMessage;
}
