import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Auth/data/data_sources/auth_local_data_source.dart';
import 'Auth/data/data_sources/auth_remote_data_source.dart';
import 'Auth/data/repository_impl/auth_repository_impl.dart';
import 'Auth/domain/use_cases/login_use_case.dart';
import 'Auth/domain/use_cases/register_use_case.dart';
import 'Auth/presentation/cubit/authcubit_cubit.dart';
import 'Auth/presentation/pages/SplashView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dataSource = AuthRemoteDataSource();
        final localDataSource = AuthLocalDataSource();
        final repository = AuthRepositoryImpl(dataSource, localDataSource);
        return AuthCubit(
          loginUseCase: LoginUseCase(repository),
          registerUseCase: RegisterUseCase(repository),
        );
      },
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bookia',
        home: SplashView(),
      ),
    );
  }
}