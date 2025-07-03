import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/utils/constants/app_assets.dart';
import 'package:flutter_news_app/utils/constants/app_colors.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String id = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home'); // your route
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsAppColors.splashScreenBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppAssets.splashAnim,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Headlyne",
                style: TextStyle(
                  color: NewsAppColors.splashScreenLogoColor,
                  fontFamily: "NewsV",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your daily dose of fresh headlines",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontFamily: "NewsV",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
