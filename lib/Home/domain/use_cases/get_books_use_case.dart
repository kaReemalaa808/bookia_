import '../entities/book_entity.dart';
import '../repository/home_repository.dart';

class GetBooksUseCase {
  final HomeRepository repository;

  GetBooksUseCase(this.repository);

  Future<List<BookEntity>> execute() {
    return repository.getBooks();
  }
}
