
import '../entites/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> execute({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}