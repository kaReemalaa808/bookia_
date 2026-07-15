import '../../domain/entities/book_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BookEntity>> getBooks() {
    return remoteDataSource.getBooks();
  }

  @override
  Future<BookEntity> getBookDetails(int id) {
    return remoteDataSource.getBookDetails(id);
  }

  @override
  Future<List<dynamic>> getWishlist() {
    return remoteDataSource.getWishlist();
  }

  @override
  Future<void> addToWishlist(int bookId) {
    return remoteDataSource.addToWishlist(bookId);
  }

  @override
  Future<void> removeFromWishlist(int wishlistId) {
    return remoteDataSource.removeFromWishlist(wishlistId);
  }

  @override
  Future<List<dynamic>> getCart() {
    return remoteDataSource.getCart();
  }

  @override
  Future<void> addToCart(int bookId) {
    return remoteDataSource.addToCart(bookId);
  }

  @override
  Future<void> updateCartQuantity(int cartId, int qty) {
    return remoteDataSource.updateCartQuantity(cartId, qty);
  }

  @override
  Future<void> removeFromCart(int cartId) {
    return remoteDataSource.removeFromCart(cartId);
  }

  @override
  Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) {
    return remoteDataSource.placeOrder(
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
  }
}
