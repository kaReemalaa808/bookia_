import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'authcubit_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({required this.loginUseCase, required this.registerUseCase})
      : super(AuthInitialState());

  void checkAuthStatus() async {
    emit(AuthLoadingState());
    try {
      final user = await loginUseCase.repository.getCachedUser();
      if (user != null) {
        emit(AuthSuccessState(user, "Welcome back! 🚀"));
      } else {
        emit(AuthInitialState());
      }
    } catch (_) {
      emit(AuthInitialState());
    }
  }

  void login({required String email, required String password}) async {
    emit(AuthLoadingState());
    try {
      final user = await loginUseCase.execute(email: email, password: password);
      await loginUseCase.repository.cacheUser(user);
      emit(AuthSuccessState(user, "Welcome Back! 🚀"));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }

  void register(
      {required String name, required String email, required String password, required String passwordConfirmation}) async {
    emit(AuthLoadingState());
    try {
      final user = await registerUseCase.execute(name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation);
      await loginUseCase.repository.cacheUser(user);
      emit(AuthSuccessState(user, "Account Created Successfully! 🎉"));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }

  void logout() async {
    emit(AuthLoadingState());
    await loginUseCase.repository.clearCache();
    
    // Clear home feature preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bookmarked_book_ids');
    await prefs.remove('cart_book_ids');
    
    emit(AuthInitialState());
  }
}