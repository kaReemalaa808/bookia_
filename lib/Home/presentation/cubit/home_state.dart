import '../../domain/entities/book_entity.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<BookEntity> books;
  final List<BookEntity> filteredBooks;
  final List<int> bookmarkedBookIds;
  final Map<int, int> wishlistIds; // bookId -> wishlistId
  final List<int> cartBookIds;
  final Map<int, int> cartIds; // bookId -> cartId
  final Map<int, int> cartBookQuantities; // bookId -> quantity
  final String searchQuery;

  HomeSuccessState({
    required this.books,
    required this.filteredBooks,
    required this.bookmarkedBookIds,
    required this.wishlistIds,
    required this.cartBookIds,
    required this.cartIds,
    required this.cartBookQuantities,
    required this.searchQuery,
  });

  HomeSuccessState copyWith({
    List<BookEntity>? books,
    List<BookEntity>? filteredBooks,
    List<int>? bookmarkedBookIds,
    Map<int, int>? wishlistIds,
    List<int>? cartBookIds,
    Map<int, int>? cartIds,
    Map<int, int>? cartBookQuantities,
    String? searchQuery,
  }) {
    return HomeSuccessState(
      books: books ?? this.books,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      bookmarkedBookIds: bookmarkedBookIds ?? this.bookmarkedBookIds,
      wishlistIds: wishlistIds ?? this.wishlistIds,
      cartBookIds: cartBookIds ?? this.cartBookIds,
      cartIds: cartIds ?? this.cartIds,
      cartBookQuantities: cartBookQuantities ?? this.cartBookQuantities,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeErrorState extends HomeStates {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}
