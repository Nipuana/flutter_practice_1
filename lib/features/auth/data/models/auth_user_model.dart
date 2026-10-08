import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.displayName,
  });

  factory AuthUserModel.fromFirebase({
    required String id,
    required String email,
    required String displayName,
  }) {
    return AuthUserModel(id: id, email: email, displayName: displayName);
  }
}
