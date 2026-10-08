import '../../../../core/session/session_storage.dart';
import '../models/auth_user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveUser(AuthUserModel user);

  Future<void> clearUser();
}

class SharedPreferencesAuthLocalDataSource implements AuthLocalDataSource {
  SharedPreferencesAuthLocalDataSource(this._storage);

  final SessionStorage _storage;

  @override
  Future<void> saveUser(AuthUserModel user) {
    return _storage.save(
      uid: user.id,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  Future<void> clearUser() => _storage.clear();
}
