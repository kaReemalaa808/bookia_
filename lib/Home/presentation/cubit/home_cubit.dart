import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitialState());

  void loadHomeData() async {
    emit(HomeLoadingState());
    try {
      final books = await repository.getBooks();
      
      // Load Wishlist
      final wishlistData = await repository.getWishlist();
      final List<int> bookmarkedBookIds = [];
      final Map<int, int> wishlistIds = {};
      
      for (var item in wishlistData) {
        if (item is Map<String, dynamic>) {
          final wishlistId = item['id'] as int?;
          final bookMap = item['book'] as Map<String, dynamic>?;
          if (wishlistId != null && bookMap != null) {
            final bookId = bookMap['id'] is int 
                ? bookMap['id'] as int 
                : int.tryParse(bookMap['id']?.toString() ?? '');
            if (bookId != null) {
              bookmarkedBookIds.add(bookId);
              wishlistIds[bookId] = wishlistId;
            }
          }
        }
      }

      // Load Cart
      final cartData = await repository.getCart();
      final List<int> cartBookIds = [];
      final Map<int, int> cartIds = {};
      final Map<int, int> cartBookQuantities = {};

      for (var item in cartData) {
        if (item is Map<String, dynamic>) {
          final cartId = item['cartId'] as int?;
          final bookId = item['bookId'] is int 
              ? item['bookId'] as int 
              : int.tryParse(item['bookId']?.toString() ?? '');
          final qty = item['qty'] is int 
              ? item['qty'] as int 
              : int.tryParse(item['qty']?.toString() ?? '') ?? 1;
              
          if (cartId != null && bookId != null) {
            cartBookIds.add(bookId);
            cartIds[bookId] = cartId;
            cartBookQuantities[bookId] = qty;
          }
        }
      }

      emit(HomeSuccessState(
        books: books,
        filteredBooks: books,
        bookmarkedBookIds: bookmarkedBookIds,
        wishlistIds: wishlistIds,
        cartBookIds: cartBookIds,
        cartIds: cartIds,
        cartBookQuantities: cartBookQuantities,
        searchQuery: '',
      ));
    } catch (e) {
      emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }

  void searchBooks(String query) {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      if (query.trim().isEmpty) {
        emit(currentState.copyWith(
          filteredBooks: currentState.books,
          searchQuery: '',
        ));
      } else {
        final filtered = currentState.books.where((book) {
          final title = book.title.toLowerCase();
          final category = book.category.toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || category.contains(searchLower);
        }).toList();
        
        emit(currentState.copyWith(
          filteredBooks: filtered,
          searchQuery: query,
        ));
      }
    }
  }

  void toggleBookmark(int bookId) async {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      try {
        final isBookmarked = currentState.bookmarkedBookIds.contains(bookId);
        if (isBookmarked) {
          final wishlistId = currentState.wishlistIds[bookId];
          if (wishlistId != null) {
            await repository.removeFromWishlist(wishlistId);
          }
        } else {
          await repository.addToWishlist(bookId);
        }
        
        // Sync wishlist from server
        final wishlistData = await repository.getWishlist();
        final List<int> updatedBookmarks = [];
        final Map<int, int> updatedWishlistIds = {};
        
        for (var item in wishlistData) {
          if (item is Map<String, dynamic>) {
            final wishlistId = item['id'] as int?;
            final bookMap = item['book'] as Map<String, dynamic>?;
            if (wishlistId != null && bookMap != null) {
              final id = bookMap['id'] is int 
                  ? bookMap['id'] as int 
                  : int.tryParse(bookMap['id']?.toString() ?? '');
              if (id != null) {
                updatedBookmarks.add(id);
                updatedWishlistIds[id] = wishlistId;
              }
            }
          }
        }
        
        emit(currentState.copyWith(
          bookmarkedBookIds: updatedBookmarks,
          wishlistIds: updatedWishlistIds,
        ));
      } catch (e) {
        emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
      }
    }
  }

  void addToCart(int bookId) async {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      try {
        await repository.addToCart(bookId);
        await _syncCartState(currentState);
      } catch (e) {
        emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
      }
    }
  }

  void removeFromCart(int bookId) async {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      try {
        final cartId = currentState.cartIds[bookId];
        if (cartId != null) {
          await repository.removeFromCart(cartId);
        }
        await _syncCartState(currentState);
      } catch (e) {
        emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
      }
    }
  }

  void updateCartQuantity(int bookId, int qty) async {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      if (qty <= 0) {
        removeFromCart(bookId);
        return;
      }
      try {
        final cartId = currentState.cartIds[bookId];
        if (cartId != null) {
          await repository.updateCartQuantity(cartId, qty);
        }
        await _syncCartState(currentState);
      } catch (e) {
        emit(HomeErrorState(e.toString().replaceAll('Exception:', '')));
      }
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    final currentState = state;
    if (currentState is HomeSuccessState) {
      try {
        final orderDetails = await repository.placeOrder(
          name: name,
          phone: phone,
          email: email,
          address: address,
        );
        
        // Order empties the remote cart automatically, so sync cart state.
        emit(currentState.copyWith(
          cartBookIds: [],
          cartIds: {},
          cartBookQuantities: {},
        ));
        
        return orderDetails;
      } catch (e) {
        throw Exception(e.toString().replaceAll('Exception:', ''));
      }
    }
    throw Exception('State is not ready.');
  }

  Future<void> _syncCartState(HomeSuccessState currentState) async {
    final cartData = await repository.getCart();
    final List<int> updatedCartBookIds = [];
    final Map<int, int> updatedCartIds = {};
    final Map<int, int> updatedCartBookQuantities = {};

    for (var item in cartData) {
      if (item is Map<String, dynamic>) {
        final cartId = item['cartId'] as int?;
        final bookId = item['bookId'] is int 
            ? item['bookId'] as int 
            : int.tryParse(item['bookId']?.toString() ?? '');
        final qty = item['qty'] is int 
            ? item['qty'] as int 
            : int.tryParse(item['qty']?.toString() ?? '') ?? 1;
            
        if (cartId != null && bookId != null) {
          updatedCartBookIds.add(bookId);
          updatedCartIds[bookId] = cartId;
          updatedCartBookQuantities[bookId] = qty;
        }
      }
    }

    emit(currentState.copyWith(
      cartBookIds: updatedCartBookIds,
      cartIds: updatedCartIds,
      cartBookQuantities: updatedCartBookQuantities,
    ));
  }
}
