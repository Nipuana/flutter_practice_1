import '../repositories/auth_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) {
    return _repository.updateProfile(
      name: name,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
