import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import '../widgets/mascot_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF58CC02),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MascotWidget(mood: MascotMood.waving, size: 110),
            SizedBox(height: 16),
            Text(
              'ENGO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
