import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../auth/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Get.offAll(
        () => const WelcomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Matrix Rain Effect
          _buildMatrixRain(),
          // Main content
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Title
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'ARCANE',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          TextSpan(
                            text: '-OPS',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: AppTheme.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '[ Initializing System ]',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Loading indicator
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixRain() {
    return CustomPaint(
      painter: MatrixRainPainter(),
      size: Size.infinite,
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  static final List<String> characters = [
    '0',
    '1',
    'あ',
    'い',
    'う',
    'え',
    'お',
    'か',
    'き',
    'く',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final random = DateTime.now().millisecond;
    for (int i = 0; i < 50; i++) {
      final x = (i * 50 + random) % size.width;
      final y = (i * 30 + random * 2) % size.height;
      final char = characters[random % characters.length];

      textPainter.text = TextSpan(
        text: char,
        style: TextStyle(
          color: AppTheme.primaryColor.withOpacity(0.08),
          fontSize: 16,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
