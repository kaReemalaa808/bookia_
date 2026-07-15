import 'package:dio/dio.dart';

import '../model/login_request_model.dart';
import '../model/register_request_model.dart';
import '../model/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.codingarabic.online/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        'user',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = response.data as Map<String, dynamic>;
      return UserModel(
        id: data['id'] ?? 0,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        token: token,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> login(LoginRequestModel request) async {
    try {
      FormData formData = FormData.fromMap(request.toMap());
      final response = await _dio.post(
        'auth/login',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final resMap = response.data as Map<String, dynamic>;
      final dataBlock = resMap['data'] as Map<String, dynamic>? ?? {};
      final token = dataBlock['token'] as String? ?? '';

      if (token.isEmpty) {
        throw Exception('لم يتم استلام رمز المصادقة من الخادم.');
      }

      return await getUserProfile(token);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> register(RegisterRequestModel request) async {
    try {
      FormData formData = FormData.fromMap(request.toMap());
      final response = await _dio.post(
        'auth/register',
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final resMap = response.data as Map<String, dynamic>;
      final dataBlock = resMap['data'] as Map<String, dynamic>? ?? {};
      final token = dataBlock['token'] as String? ?? '';

      if (token.isEmpty) {
        throw Exception('لم يتم استلام رمز المصادقة من الخادم.');
      }

      return await getUserProfile(token);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return Exception(
        e.response?.data['message'] ?? 'حدث خطأ ما، تأكد من البيانات!',
      );
    }
    return Exception('مشكلة في الشبكة، تأكد من اتصالك بالإنترنت.');
  }
}
