import 'package:flutter/material.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "تم بنجاح 🎉",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "تم تنفيذ عملية الشراء بنجاح.\nشكراً لتسوقك معنا ❤️",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC3A15C),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      "العودة للرئيسية",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
