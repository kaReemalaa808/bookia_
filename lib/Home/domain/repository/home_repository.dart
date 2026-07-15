import '../entities/book_entity.dart';

abstract class HomeRepository {
  Future<List<BookEntity>> getBooks();
  Future<BookEntity> getBookDetails(int id);

  // Wishlist API Methods
  Future<List<dynamic>> getWishlist();
  Future<void> addToWishlist(int bookId);
  Future<void> removeFromWishlist(int wishlistId);

  // Cart API Methods
  Future<List<dynamic>> getCart();
  Future<void> addToCart(int bookId);
  Future<void> updateCartQuantity(int cartId, int qty);
  Future<void> removeFromCart(int cartId);

  // Orders API Methods
  Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String phone,
    required String email,
    required String address,
  });
}
