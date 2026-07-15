import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/authcubit_cubit.dart';
import '../cubit/authcubit_state.dart';
import 'RegisterView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF8391A1), fontSize: 15),
      filled: true,
      fillColor: const Color(0xFFF7F8F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE8ECF4), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC3A15C), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE8ECF4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1E232C),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Heading
                const Text(
                  'Welcome back! Glad\nto see you, Again!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                    color: Color(0xFF1E232C),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 32),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email is required';
                    if (!val.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                  decoration: _buildInputDecoration(hintText: 'Enter your email'),
                ),
                const SizedBox(height: 15),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Password is required';
                    if (val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF8391A1),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                ),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot Password clicked')),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF6A707C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Login Button
                BlocConsumer<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if (state is AuthSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Pop back to the root AuthWrapper which will automatically show SuccessHomeView
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                    if (state is AuthErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC3A15C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: state is AuthLoadingState
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                }
                              },
                        child: state is AuthLoadingState
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 35),
                // Or separator
                const Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFFE8ECF4), thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Or',
                        style: TextStyle(
                          color: Color(0xFF6A707C),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFE8ECF4), thickness: 1)),
                  ],
                ),
                const SizedBox(height: 25),
                // Social buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE8ECF4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google Sign-In placeholder')),
                      );
                    },
                    icon: CustomPaint(
                      size: const Size(20, 20),
                      painter: GoogleLogoPainter(),
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE8ECF4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Apple Sign-In placeholder')),
                      );
                    },
                    icon: const Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 24,
                    ),
                    label: const Text(
                      'Sign in with Apple',
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const RegisterView()),
                        );
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          color: Color(0xFFC3A15C),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Success Home View to display after login/register
class SuccessHomeView extends StatelessWidget {
  final String userName;
  final String token;

  const SuccessHomeView({
    super.key,
    required this.userName,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        title: const Text('Bookia Home 📚', style: TextStyle(fontFamily: 'Georgia', color: Color(0xFF1E232C))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF1E232C)),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xFFC3A15C), size: 100),
              const SizedBox(height: 20),
              Text(
                'Welcome, $userName!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E232C),
                  fontFamily: 'Georgia',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'You have successfully integrated the API and logged into Bookia.',
                style: TextStyle(fontSize: 15, color: Color(0xFF6A707C)),
                textAlign: TextAlign.center,
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
                      'Access Token:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      token,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Google multi-colored G logo
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    // Red Arc (top)
    paint.color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(r, r)
      ..lineTo(w * 0.15, h * 0.25)
      ..arcTo(Rect.fromCircle(center: Offset(r, r), radius: r), -2.356, 1.57, false)
      ..lineTo(r, r)
      ..close();
    canvas.drawPath(redPath, paint);

    // Yellow Arc (left)
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(r, r)
      ..lineTo(w * 0.15, h * 0.25)
      ..arcTo(Rect.fromCircle(center: Offset(r, r), radius: r), -2.356, -1.57, false)
      ..lineTo(r, r)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Green Arc (bottom)
    paint.color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(r, r)
      ..lineTo(w * 0.15, h * 0.75)
      ..arcTo(Rect.fromCircle(center: Offset(r, r), radius: r), 2.356, -1.57, false)
      ..lineTo(r, r)
      ..close();
    canvas.drawPath(greenPath, paint);

    // Blue Arc (right)
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(r, r)
      ..lineTo(w * 0.85, h * 0.75)
      ..arcTo(Rect.fromCircle(center: Offset(r, r), radius: r), 0.785, -1.57, false)
      ..lineTo(r, r)
      ..close();
    canvas.drawPath(bluePath, paint);

    // Blue horizontal bar
    final barPath = Path()
      ..moveTo(r, r)
      ..lineTo(w * 0.95, r)
      ..lineTo(w * 0.95, r * 1.25)
      ..lineTo(r, r * 1.25)
      ..close();
    canvas.drawPath(barPath, paint);

    // White inner cutout
    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(r, r), r * 0.65, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}