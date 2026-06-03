import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../services/firebase_service.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final bool isEmailVerification;
  final String verificationId; // For phone verification

  const VerificationScreen({
    Key? key,
    required this.email,
    required this.phoneNumber,
    this.isEmailVerification = false,
    this.verificationId = '',
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _codeControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            _startResendTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _handleCodeInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _handleBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeControllers.map((c) => c.text).join();

    if (code.length != 6) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer le code à 6 chiffres',
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.backgroundColor,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.isEmailVerification) {
        await _firebaseService.verifyEmailCode(code);
        Get.snackbar(
          'Succès',
          'Email vérifié avec succès!',
          backgroundColor: AppTheme.successColor,
          colorText: AppTheme.backgroundColor,
        );
        // Navigate to home/dashboard
        Get.offNamed('/home');
      } else {
        // Phone verification
        await _firebaseService.verifyPhoneCode(widget.verificationId, code);
        Get.snackbar(
          'Succès',
          'Numéro de téléphone vérifié!',
          backgroundColor: AppTheme.successColor,
          colorText: AppTheme.backgroundColor,
        );
        // Navigate to home/dashboard
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.backgroundColor,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resendCode() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _startResendTimer();

    Get.snackbar(
      'Info',
      'Code renvoyé à ${widget.isEmailVerification ? widget.email : widget.phoneNumber}',
      backgroundColor: AppTheme.secondaryColor,
      colorText: AppTheme.backgroundColor,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              _buildMatrixBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          'VÉRIFICATION',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entrez le code envoyé à ${widget.isEmailVerification ? widget.email : widget.phoneNumber}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                        ),
                        const SizedBox(height: 48),
                        // Code input boxes
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              6,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: 50,
                                  height: 60,
                                  child: TextField(
                                    controller: _codeControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        _handleBackspace(value, index);
                                      } else if (value.length == 1) {
                                        _handleCodeInput(value, index);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Verify button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyCode,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.backgroundColor,
                                    ),
                                  )
                                : const Text('VÉRIFIER'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Resend code
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Vous n\'avez pas reçu le code?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              _canResend
                                  ? GestureDetector(
                                      onTap: _resendCode,
                                      child: Text(
                                        'Renvoyer le code',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Renvoyer dans $_secondsRemaining secondes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.errorColor,
                                          ),
                                    ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildMatrixBackground() {
    return CustomPaint(
      painter: MatrixRainPainter(),
      size: Size.infinite,
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.03)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
