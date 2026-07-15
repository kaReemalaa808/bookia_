import 'package:dio/dio.dart';
import '../model/book_model.dart';

class HomeRemoteDataSource {
  final String token;
  late final Dio _dio;

  HomeRemoteDataSource({required this.token}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.codingarabic.online/api/',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<List<BookModel>> getBooks() async {
    try {
      final response = await _dio.get('books');

      final resMap = response.data as Map<String, dynamic>;
      final dataList = resMap['data'] as List<dynamic>? ?? [];

      return dataList
          .map((json) => BookModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<BookModel> getBookDetails(int id) async {
    try {
      final response = await _dio.get('books/$id');

      final responseMap = response.data as Map<String, dynamic>;
      final bookData = responseMap['data'] as Map<String, dynamic>;

      return BookModel.fromJson(bookData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Wishlist API Methods
  Future<List<dynamic>> getWishlist() async {
    try {
      final response = await _dio.get('wishlist/get');
      final resMap = response.data as Map<String, dynamic>;
      return resMap['data'] as List<dynamic>? ?? [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addToWishlist(int bookId) async {
    try {
      await _dio.post(
        'wishlist/add',
        data: FormData.fromMap({'bookId': bookId}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> removeFromWishlist(int wishlistId) async {
    try {
      await _dio.post(
        'wishlist/remove',
        data: FormData.fromMap({'wishlistId': wishlistId}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Cart API Methods
  Future<List<dynamic>> getCart() async {
    try {
      final response = await _dio.get('cart');
      final resMap = response.data as Map<String, dynamic>;
      return resMap['data'] as List<dynamic>? ?? [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        return [];
      }
      throw _handleDioError(e);
    }
  }

  Future<void> addToCart(int bookId) async {
    try {
      await _dio.post('cart', data: FormData.fromMap({'bookId': bookId}));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateCartQuantity(int cartId, int qty) async {
    try {
      await _dio.post('cart/$cartId', data: FormData.fromMap({'qty': qty}));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> removeFromCart(int cartId) async {
    try {
      await _dio.delete('cart/$cartId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Orders API Methods
  Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      final response = await _dio.post(
        'orders',
        data: FormData.fromMap({
          'customerName': name,
          'customerPhone': phone,
          'customerEmail': email,
          'customerAddress': address,
        }),
      );
      final resMap = response.data as Map<String, dynamic>;
      return resMap['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return Exception(
        e.response?.data['message'] ??
            'حدث خطأ أثناء تحميل البيانات من الخادم.',
      );
    }
    return Exception(
      'مشكلة في الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت.',
    );
  }
}
