import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_profile.dart';

enum AuthStatus { loading, unauthenticated, authenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._repository,
    this._signIn,
    this._register,
    this._updateProfile,
    this._signOut,
  ) : super(const AuthState()) {
    _authSubscription = _repository.authStateChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  final SignIn _signIn;
  final Register _register;
  final UpdateProfile _updateProfile;
  final SignOut _signOut;
  late final StreamSubscription<AuthUser?> _authSubscription;

  Future<void> _onAuthChanged(AuthUser? user) async {
    emit(
      user == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> signIn(String email, String password) {
    return _run(() => _signIn(email: email, password: password));
  }

  Future<void> register(String name, String email, String password) {
    return _run(
      () => _register(name: name, email: email, password: password),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) {
    return _run(
      () => _updateProfile(
        name: name,
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> signOut() => _signOut();

  Future<void> _run(Future<void> Function() action) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await action();
      final user = _repository.currentUser;
      if (user != null) {
        emit(AuthState(status: AuthStatus.authenticated, user: user));
      }
    } on AuthFailure catch (error) {
      emit(
        state.copyWith(
          status: state.user == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          errorMessage: error.message,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
