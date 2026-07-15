import '../../domain/entites/user_entity.dart';

import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../model/login_request_model.dart';
import '../model/register_request_model.dart';
import '../model/user_model.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    return await remoteDataSource.login(
        LoginRequestModel(email: email, password: password));
  }

  @override
  Future<UserEntity> register(
      {required String name, required String email, required String password, required String passwordConfirmation}) async {
    return await remoteDataSource.register(RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ));
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    return await localDataSource.getCachedUser();
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    if (user is UserModel) {
      await localDataSource.cacheUser(user);
    }
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}