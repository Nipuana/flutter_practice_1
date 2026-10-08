import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  SessionStorage(this._preferences);

  final SharedPreferences _preferences;

  static const _uidKey = 'session_uid';
  static const _emailKey = 'session_email';
  static const _displayNameKey = 'session_display_name';

  Future<void> save({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    await _preferences.setString(_uidKey, uid);
    await _preferences.setString(_emailKey, email);
    await _preferences.setString(_displayNameKey, displayName);
  }

  Future<void> clear() async {
    await Future.wait([
      _preferences.remove(_uidKey),
      _preferences.remove(_emailKey),
      _preferences.remove(_displayNameKey),
    ]);
  }
}
