import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> updateProfile({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  });

  Future<void> signOut();
}
