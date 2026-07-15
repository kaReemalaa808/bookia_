import '../../domain/entites/user_entity.dart';

abstract class AuthStates {}
class AuthInitialState extends AuthStates {}
class AuthLoadingState extends AuthStates {}
class AuthSuccessState extends AuthStates {
  final UserEntity user;
  final String message;
  AuthSuccessState(this.user, this.message);
}
class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}