import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bookia_logo.dart';
import 'AuthWrapper.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BookiaLogo(
              iconSize: 60.0,
              fontSize: 54.0,
              spacing: 16.0,
            ),
            SizedBox(height: 15),
            Text(
              'Order Your Book Now!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Georgia',
                color: Color(0xFF1E232C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
