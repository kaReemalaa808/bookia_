import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Auth/presentation/cubit/authcubit_cubit.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'HomeView.dart';
import 'BookDetailsView.dart';
import 'OrderSuccessView.dart';

class MainDashboardView extends StatefulWidget {
  final String userName;
  final String email;

  const MainDashboardView({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  State<MainDashboardView> createState() => _MainDashboardViewState();
}

class _MainDashboardViewState extends State<MainDashboardView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const BookmarksTab(),
      CartTab(userName: widget.userName),
      ProfileTab(userName: widget.userName, email: widget.email),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFC3A15C),
        unselectedItemColor: const Color(0xFF8391A1),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= Bookmarks Tab =================

class BookmarksTab extends StatelessWidget {
  const BookmarksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8F9),
        elevation: 0,
        title: const Text(
          'My Bookmarks',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E232C),
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is HomeSuccessState) {
            final bookmarkedBooks = state.books
                .where((book) => state.bookmarkedBookIds.contains(book.id))
                .toList();

            if (bookmarkedBooks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: Color(0xFF8391A1),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Bookmarks Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on details screen\nto save your favorite books here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedBooks.length,
              itemBuilder: (context, index) {
                final book = bookmarkedBooks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE8ECF4)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.imageUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 70,
                            color: const Color(0xFFE8ECF4),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Color(0xFF8391A1),
                              size: 28,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      book.category,
                      style: const TextStyle(
                        color: Color(0xFFC3A15C),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.bookmark_remove,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        context.read<HomeCubit>().toggleBookmark(book.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: context.read<HomeCubit>(),
                            child: BookDetailsView(book: book),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC3A15C)),
          );
        },
      ),
    );
  }
}
// ================= Cart Tab =================

class CartTab extends StatelessWidget {
  final String userName;

  const CartTab({super.key, required this.userName});

  void _showCheckoutBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: userName);
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Checkout Delivery Details 📦',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: Color(0xFF1E232C),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Name',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Phone',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Email',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Required';
                      }

                      if (!v.contains('@')) {
                        return 'Invalid email';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC3A15C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(bottomSheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Placing order... ⏳')),
                          );

                          try {
                            final orderDetails = await context
                                .read<HomeCubit>()
                                .placeOrder(
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  email: emailController.text.trim(),
                                  address: addressController.text.trim(),
                                );

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OrderSuccessView(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8F9),
        elevation: 0,
        title: const Text(
          'My Cart 🛒',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E232C),
          ),
        ),
      ),

      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is HomeSuccessState) {
            final cartBooks = state.books
                .where((book) => state.cartBookIds.contains(book.id))
                .toList();

            if (cartBooks.isEmpty) {
              return const Center(
                child: Text(
                  'Your Cart is Empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: cartBooks.length,

              itemBuilder: (context, index) {
                final book = cartBooks[index];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.network(
                        book.imageUrl,

                        width: 50,

                        height: 70,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,

                            height: 70,

                            color: const Color(0xFFE8ECF4),

                            child: const Icon(
                              Icons.broken_image_outlined,

                              color: Color(0xFF8391A1),
                            ),
                          );
                        },
                      ),
                    ),

                    title: Text(book.title),

                    subtitle: Text(book.price),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC3A15C)),
          );
        },
      ),
    );
  }
}
// ================= Profile Tab =================

class ProfileTab extends StatelessWidget {
  final String userName;
  final String email;

  const ProfileTab({super.key, required this.userName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8F9),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E232C),
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE8ECF4),

                child: Icon(Icons.person, size: 60, color: Color(0xFFC3A15C)),
              ),

              const SizedBox(height: 20),

              Text(
                userName,

                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,

                  color: Color(0xFF1E232C),

                  fontFamily: 'Georgia',
                ),

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Signed in with Bookia API',

                style: TextStyle(fontSize: 14, color: Color(0xFF6A707C)),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: const Color(0xFFE8ECF4)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Email:',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        color: Color(0xFF1E232C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    SelectableText(
                      email,

                      style: TextStyle(
                        fontSize: 12,

                        color: Colors.grey[700],

                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                height: 52,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },

                  icon: const Icon(Icons.logout, color: Colors.white),

                  label: const Text(
                    'Logout',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
