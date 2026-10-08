import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AuthUserModel?> get authStateChanges;

  AuthUserModel? get currentUser;

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

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this._auth);

  final FirebaseAuth _auth;

  AuthUserModel? _toModel(User? user) {
    if (user == null) return null;
    return AuthUserModel.fromFirebase(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  @override
  Stream<AuthUserModel?> get authStateChanges =>
      _auth.authStateChanges().map(_toModel);

  @override
  AuthUserModel? get currentUser => _toModel(_auth.currentUser);

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'You must be signed in to edit your profile.',
      );
    }

    final emailChanged = email.trim() != (user.email ?? '');
    final password = newPassword;
    final passwordChanged = password?.isNotEmpty ?? false;
    if ((emailChanged || passwordChanged) &&
        (currentPassword == null || currentPassword.isEmpty)) {
      throw FirebaseAuthException(
        code: 'requires-recent-login',
        message: 'Enter your current password to change email or password.',
      );
    }

    if (emailChanged || passwordChanged) {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email ?? '',
          password: currentPassword!,
        ),
      );
    }
    if (name.trim() != (user.displayName ?? '')) {
      await user.updateDisplayName(name.trim());
    }
    if (emailChanged) {
      await user.verifyBeforeUpdateEmail(email.trim());
    }
    if (passwordChanged) {
      await user.updatePassword(password!);
    }
    await user.reload();
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
