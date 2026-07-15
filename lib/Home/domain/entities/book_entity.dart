class BookEntity {
  final int id;
  final String title;
  final String category;
  final String description;
  final String price;
  final String imageUrl;

  BookEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
