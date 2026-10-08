import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Stream<AuthUser?> get authStateChanges => _remote.authStateChanges.asyncMap(
        (user) async {
          if (user == null) {
            await _local.clearUser();
          } else {
            await _local.saveUser(user);
          }
          return user;
        },
      );

  @override
  AuthUser? get currentUser => _remote.currentUser;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _execute(() => _remote.signIn(email: email, password: password));
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _execute(
      () => _remote.register(name: name, email: email, password: password),
    );
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) async {
    await _execute(
      () => _remote.updateProfile(
        name: name,
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    final user = _remote.currentUser;
    if (user != null) await _local.saveUser(user);
  }

  @override
  Future<void> signOut() async {
    await _execute(_remote.signOut);
    await _local.clearUser();
  }

  Future<void> _execute(Future<void> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  String _messageFor(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-credential' || 'user-not-found' || 'wrong-password' =>
        'The email or password is incorrect.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Use a password with at least 6 characters.',
      'invalid-email' => 'Enter a valid email address.',
      'requires-recent-login' =>
        error.message ?? 'Please sign in again and try again.',
      _ => error.message ?? 'Authentication failed. Please try again.',
    };
  }
}
