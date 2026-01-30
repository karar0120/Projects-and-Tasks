import 'package:dartz/dartz.dart';
import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/features/auth/data/constants/auth_api_constants.dart';
import 'package:projectsandtasks/features/auth/data/models/login_request.dart';
import 'package:projectsandtasks/features/auth/data/models/login_response.dart';
import 'package:projectsandtasks/features/auth/data/models/register_request.dart';

/// Remote data source for auth API (login, register).
/// Uses [WebService] and [getRequestHeadersNoToken] for unauthenticated requests.
abstract class AuthRemoteDataSource {
  Future<Either<ApiErrorModel, LoginResponse>> login(LoginRequest request);
  Future<Either<ApiErrorModel, void>> register(RegisterRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Either<ApiErrorModel, LoginResponse>> login(LoginRequest request) async {
    final response = await WebService.postNoLang(
      controller: AuthApiConstants.baseUrl,
      endpoint: AuthApiConstants.loginEndpoint,
      headers: WebService.getRequestHeadersNoToken(),
      body: request.toJson(),
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! Map<String, dynamic>) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        return right(LoginResponse.fromJson(data));
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, void>> register(RegisterRequest request) async {
    final response = await WebService.postNoLang(
      controller: AuthApiConstants.baseUrl,
      endpoint: AuthApiConstants.registerEndpoint,
      headers: WebService.getRequestHeadersNoToken(),
      body: request.toJson(),
    );

    return response.fold(
      (error) => left(error),
      (_) => right(null),
    );
  }
}
