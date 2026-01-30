import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/features/auth/data/models/login_request.dart';
import 'package:projectsandtasks/features/auth/data/models/login_response.dart';
import 'package:projectsandtasks/features/auth/data/models/register_request.dart';
import 'package:projectsandtasks/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:projectsandtasks/features/auth/domain/repositories/auth_repository.dart';

/// Base state for auth operations.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess(this.response);
  final LoginResponse response;
}

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

/// Cubit for login and register. Uses [AuthRepository].
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl(),
        super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    if (username.trim().isEmpty || password.isEmpty) {
      emit(const AuthError('Please enter username and password'));
      return;
    }
    emit(const AuthLoading());
    try {
      final request = LoginRequest(username: username.trim(), password: password);
      final response = await _repository.login(request);
      emit(AuthLoginSuccess(response));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String username, String email, String password) async {
    final u = username.trim();
    final e = email.trim();
    if (u.isEmpty || e.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill all fields'));
      return;
    }
    emit(const AuthLoading());
    try {
      final request = RegisterRequest(username: u, email: e, password: password);
      await _repository.register(request);
      emit(const AuthRegisterSuccess());
    } on AuthException catch (ex) {
      emit(AuthError(ex.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void clearError() {
    if (state is AuthError) emit(const AuthInitial());
  }
}
