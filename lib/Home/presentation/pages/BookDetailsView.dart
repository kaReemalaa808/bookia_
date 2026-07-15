import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class BookDetailsView extends StatelessWidget {
  final BookEntity book;

  const BookDetailsView({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF7F8F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF1E232C)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          BlocBuilder<HomeCubit, HomeStates>(
            builder: (context, state) {
              bool isBookmarked = false;
              if (state is HomeSuccessState) {
                isBookmarked = state.bookmarkedBookIds.contains(book.id);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF7F8F9),
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 20,
                      color: isBookmarked ? const Color(0xFFC3A15C) : const Color(0xFF1E232C),
                    ),
                    onPressed: () {
                      context.read<HomeCubit>().toggleBookmark(book.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBookmarked
                                ? 'Removed "${book.title}" from Bookmarks'
                                : 'Added "${book.title}" to Bookmarks',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Book Cover Card
                    Container(
                      height: 320,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: 'book_image_${book.id}',
                          child: book.imageUrl.isNotEmpty
                              ? Image.network(
                                  book.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFE8ECF4),
                                      child: const Center(
                                        child: Icon(Icons.book_rounded, size: 80, color: Color(0xFFC3A15C)),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: const Color(0xFFE8ECF4),
                                  child: const Center(
                                    child: Icon(Icons.book_rounded, size: 80, color: Color(0xFFC3A15C)),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Book Title
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E232C),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Category / Subtitle
                    Text(
                      book.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC3A15C),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Divider
                    Container(
                      width: 60,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3A15C).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Description Label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E232C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Description Paragraph
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A707C),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price Tag
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8391A1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E232C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 28),
                  
                  // Add to Cart Button
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeStates>(
                      builder: (context, state) {
                        bool isInCart = false;
                        if (state is HomeSuccessState) {
                          isInCart = state.cartBookIds.contains(book.id);
                        }
                        
                        return SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInCart ? const Color(0xFF34C759) : const Color(0xFF2F2F2F),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (isInCart) {
                                context.read<HomeCubit>().removeFromCart(book.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed "${book.title}" from Cart 🛒'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                context.read<HomeCubit>().addToCart(book.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added "${book.title}" to Cart 🛒'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isInCart ? Icons.check_circle_outline : Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isInCart ? 'Added To Cart' : 'Add To Cart',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
