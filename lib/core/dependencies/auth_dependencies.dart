import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/session/session_storage.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/update_profile.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

abstract final class AuthDependencies {
  static AuthCubit createCubit(SharedPreferences preferences) {
    final repository = AuthRepositoryImpl(
      FirebaseAuthRemoteDataSource(FirebaseAuth.instance),
      SharedPreferencesAuthLocalDataSource(SessionStorage(preferences)),
    );

    return AuthCubit(
      repository,
      SignIn(repository),
      Register(repository),
      UpdateProfile(repository),
      SignOut(repository),
    );
  }
}
