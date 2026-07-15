import '../entites/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<UserEntity?> getCachedUser();

  Future<void> cacheUser(UserEntity user);

  Future<void> clearCache();

}